import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/data/models/payment_details_model.dart';
import 'package:line_skip/data/models/receipt_model.dart';
import 'package:line_skip/data/models/transaction_model.dart';
import 'package:line_skip/providers/ble_provider.dart';
import 'package:line_skip/providers/cart_provider.dart';
import 'package:line_skip/providers/current_user_provider.dart';
import 'package:line_skip/providers/inventory_provider.dart';
import 'package:line_skip/providers/store_provider.dart';
import 'package:line_skip/screens/payment/payment_confirmation_page.dart';
import 'package:line_skip/screens/store/store_page.dart';
import 'package:line_skip/utils/constants.dart';

void success(BuildContext context, WidgetRef ref, String responseString,
    String paymentApp) {
  final cartNotifier = ref.read(cartItemsProvider.notifier);
  final selectedStore = ref.watch(selectedStoreProvider);
  final cartItems = ref.watch(cartItemsProvider);

  final String userid = ref.read(currentUserProvider)!.id;

  if (selectedStore == null) return;

  String transactionId = '';
  String approvalRefNo = '';
  String responseCode = '';
  String txnRef = '';
  UpiTransactionStatus status = UpiTransactionStatus.success;

  final fragments = responseString.split('&');
  for (final fragment in fragments) {
    final keyValuePair = fragment.split('=');
    if (keyValuePair.length != 2) continue;

    final key = keyValuePair.first.toLowerCase();
    final value = keyValuePair.last;

    switch (key) {
      case 'txnid':
        transactionId = value;
        break;
      case 'responsecode':
        responseCode = '00';
        break;
      case 'approvalrefno':
        approvalRefNo = value;
        break;
      case 'status':
        final lower = value.toLowerCase();
        if (lower.contains('success') || lower == 's') {
          status = UpiTransactionStatus.success;
        } else if (lower.contains('submitted')) {
          status = UpiTransactionStatus.success;
        } else if (lower.contains('fail')) {
          status = UpiTransactionStatus.success;
        } else {
          status = UpiTransactionStatus.success;
        }
        break;
      case 'txnref':
        txnRef = value;
        break;
    }
  }

  final transactionDetail = TransactionModel(
    userid: userid,
    transactionId: transactionId,
    amount: cartNotifier.calculateTotalPrice(),
    status: UpiTransactionStatus.success.toString(),
    transactionRef: txnRef,
    approvalRefNo: approvalRefNo,
    responseCode: responseCode,
    receiverName: selectedStore.name,
    receiverUpiAddress: selectedStore.storeUpiId,
    upiApplication: paymentApp,
    transactionNote: 'Line Skip Payment',
    statusEnum: status,
  );

  final paymentDetails = PaymentDetails(
    totalAmount: cartNotifier.calculateTotalPrice(),
    tax: 0.0,
    discount: 0.0,
  );

  final receipt = ReceiptModel(
    user: userid,
    transactionId: transactionDetail.transactionId,

    //store
    items: cartItems,
    store: selectedStore,

    //transaction
    transactionDetails: transactionDetail,
    paymentDetails: paymentDetails,
  );

  dev.log(receipt.toJson().toString(), name: 'Receipt JSON');

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => PaymentConfirmationPage()),
    ModalRoute.withName(authRoute),
  );
// Delay cleanup to the next frame
  WidgetsBinding.instance.addPostFrameCallback((_) {
    cartNotifier.resetCart();
    ref.invalidate(currentPageProvider);
    ref.invalidate(inventoryProvider);
    ref.invalidate(selectedStoreProvider);
    ref.read(bleProvider.notifier).disconnect();
  });
}
