import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_skip/data/models/item_model.dart';
import 'package:line_skip/data/models/store_model.dart';
import 'package:line_skip/data/models/transaction_model.dart';
import 'package:line_skip/data/models/user_model.dart';

import 'payment_details_model.dart';

class ReceiptModel {
  final String receiptId;
  final String userId;
  final UserModel user;
  final List<Item> items;
  final Store store;
  final double invoiceTotal;
  final String transactionId;
  final PaymentDetails paymentDetails;
  final TransactionModel transactionDetails;
  final DateTime createdAt;

  ReceiptModel({
    String? receiptId,
    required this.userId,
    required this.user,
    required this.items,
    required this.store,
    required this.invoiceTotal,
    required this.transactionId,
    required this.paymentDetails,
    required this.transactionDetails,
    DateTime? createdAt,
  }) : receiptId = receiptId ?? _generateReceiptId(),
       createdAt = createdAt ?? DateTime.now();

  double get totalAmount => items.fold(0.0, (sum, item) => sum + item.price);

  Map<String, dynamic> toJson() => {
    'receiptId': receiptId,
    'userId': userId,
    'user': user.toJson(),
    'items': items.map((i) => i.toJson()).toList(),
    'store': store.toJson(),
    'invoiceTotal': invoiceTotal,
    'transactionId': transactionId,
    'paymentDetails': paymentDetails.toJson(),
    'transactionDetails': transactionDetails.toJson(),
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    final dynamic timestamp = json['createdAt'];
    DateTime? createdAt;
    if (timestamp is Timestamp) {
      createdAt = timestamp.toDate();
    }

    return ReceiptModel(
      receiptId: json['receiptId'],
      userId: json['userId'],
      user: UserModel.fromJson(json['user']),
      items: (json['items'] as List).map((e) => Item.fromJson(e)).toList(),
      store: Store.fromJson(json['store']),
      invoiceTotal: (json['invoiceTotal'] as num).toDouble(),
      transactionId: json['transactionId'],
      paymentDetails: PaymentDetails.fromJson(json['paymentDetails']),
      transactionDetails: TransactionModel.fromJson(json['transactionDetails']),
      createdAt: createdAt,
    );
  }
}

String _generateReceiptId() {
  final now = DateTime.now();
  final timestamp = now.millisecondsSinceEpoch;
  final random = DateTime.now().microsecondsSinceEpoch % 100000;
  return 'LSRCPT-$timestamp-$random';
}
