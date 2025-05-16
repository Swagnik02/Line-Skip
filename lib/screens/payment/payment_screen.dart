import 'dart:developer' as dev;
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/providers/cart_provider.dart';
import 'package:line_skip/providers/receipt_provider.dart';
import 'package:line_skip/providers/store_provider.dart';
import 'package:line_skip/widgets/verification_laoder.dart';
import 'package:line_skip/utils/payment_helpers.dart';
import 'package:line_skip/utils/payment_success.dart';
import 'package:line_skip/widgets/custom_app_bar.dart';
import 'package:line_skip/widgets/custom_elevated_button.dart';
import 'package:upi_pay/upi_pay.dart';

enum PaymentMethod { Card, GooglePay, UPI }
// Keep your imports the same

class PaymentScreen extends ConsumerStatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  PaymentMethod? _selectedPaymentMethod = PaymentMethod.Card;
  int? _selectedUpiAppIndex;
  String? _upiAddrError;
  bool _isProcessingPayment = false;
  bool _isSimulatePayment = kDebugMode;

  final _upiPayPlugin = UpiPay();
  List<ApplicationMeta>? _apps;
  late UpiTransactionResponse transaction;

  @override
  void initState() {
    super.initState();
    _loadUpiApps();
  }

  Future<void> _loadUpiApps() async {
    _apps = await _upiPayPlugin.getInstalledUpiApplications(
      statusType: UpiApplicationDiscoveryAppStatusType.all,
    );
    setState(() {});
  }

  void _setPaymentMethod(PaymentMethod? method) {
    setState(() {
      _selectedPaymentMethod = method;
      _selectedUpiAppIndex = null;
    });
  }

  Future<void> _handleUPI(ApplicationMeta app) async {
    final store = ref.watch(selectedStoreProvider);
    final cart = ref.read(cartItemsProvider.notifier);
    final upiId = store?.storeUpiId ?? '';

    final error = validateUpiAddress(upiId);
    if (error != null) {
      _showSnackBar(error, isError: true);
      return;
    }

    setState(() => _isProcessingPayment = true);

    final transactionRef = Random.secure().nextInt(1 << 32).toString();

    try {
      transaction = await _upiPayPlugin.initiateTransaction(
        amount: cart.calculateInvoiceTotal().toStringAsFixed(2),
        app: app.upiApplication,
        receiverName: store?.name ?? '',
        receiverUpiAddress: upiId,
        transactionRef: transactionRef,
        transactionNote: 'Line Skip Payment',
      );

      // Upi transaction manipulation, comment out in production
      await Future.delayed(Duration(seconds: 2));
      transaction = manipulateResponse(
        transaction.rawResponse!,
        transactionRef,
      );
      // End of manipulation

      dev.log(transaction.toString(), name: 'UPI Transaction');

      _handleTransactionStatus(transaction.status);
    } catch (_) {
      _showSnackBar('An error occurred during transaction.', isError: true);
    } finally {
      // setState(() => _isProcessingPayment = false);
    }
  }

  void _handleTransactionStatus(UpiTransactionStatus? status) async {
    if (status == UpiTransactionStatus.success) {
      await _processSuccess();
      await Future.delayed(Duration(seconds: 4));

      return;
      // _showSnackBar('Transaction successful.');
    } else {
      _showSnackBar('Transaction failed or cancelled.', isError: true);
    }
  }

  void _handlePay() async {
    switch (_selectedPaymentMethod) {
      case PaymentMethod.Card:
        _showSnackBar('Card payment is not implemented.', isError: true);
        break;
      case PaymentMethod.GooglePay:
        final app = _apps?.firstWhere(
          (app) => app.upiApplication == UpiApplication.googlePay,
        );

        if (app != null) {
          await _handleUPI(app);
        } else {
          _showSnackBar('Google Pay is not installed.', isError: true);
        }
        break;

      case PaymentMethod.UPI:
        if (_selectedUpiAppIndex != null && _apps?.isNotEmpty == true) {
          await _handleUPI(_apps![_selectedUpiAppIndex!]);
        } else {
          _showSnackBar('Please select a UPI app.', isError: true);
        }
        break;
      default:
        _showSnackBar('Select a payment method.', isError: true);
    }
  }

  Future<void> _simulatePayment() async {
    setState(() => _isProcessingPayment = true);
    final transactionRef = Random.secure().nextInt(1 << 32).toString();

    try {
      transaction = simulateSuccessTransactionResponse(transactionRef);
      _handleTransactionStatus(transaction.status);
    } catch (_) {
      _showSnackBar('An error occurred during transaction.', isError: true);
    } finally {
      // setState(() => _isProcessingPayment = false);
    }
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  Widget _buildUpiAppList() {
    if (_apps == null || _apps!.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(
          'Available UPI Apps',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 12),
        ..._apps!.asMap().entries.map((entry) {
          final index = entry.key;
          final app = entry.value;
          return Column(
            children: [
              ListTile(
                leading: app.iconImage(40),
                title: Text(app.upiApplication.getAppName()),
                trailing: Radio<int>(
                  value: index,
                  groupValue: _selectedUpiAppIndex,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = PaymentMethod.UPI;
                      _selectedUpiAppIndex = value;
                    });
                  },
                ),
              ),
              Divider(),
            ],
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartItemsProvider.notifier);
    final total = cart.calculateInvoiceTotal().toStringAsFixed(2);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Payment Options',
        actions: [
          Switch(
            value: _isSimulatePayment,
            onChanged: (value) {
              setState(() {
                _isSimulatePayment = value;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (_upiAddrError != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _upiAddrError!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                Expanded(
                  child: ListView(
                    children: [
                      Text(
                        'Preferred Payment',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildPaymentOption(
                        'Card Payment',
                        PaymentMethod.Card,
                        Icons.credit_card,
                      ),
                      Divider(),
                      _buildPaymentOption(
                        'Google Pay',
                        PaymentMethod.GooglePay,
                        Icons.account_balance_wallet,
                      ),
                      Divider(),
                      _buildUpiAppList(),
                    ],
                  ),
                ),
                _isSimulatePayment
                    ? CustomElevatedButton(
                      title: 'Pay ₹$total',
                      onPressed: _simulatePayment,
                    )
                    : CustomElevatedButton(
                      title: 'Pay ₹$total',
                      onPressed: _handlePay,
                    ),
              ],
            ),
          ),
          if (_isProcessingPayment) VerificationLoader(),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    String title,
    PaymentMethod method,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Radio<PaymentMethod>(
        value: method,
        groupValue: _selectedPaymentMethod,
        onChanged: (value) => _setPaymentMethod(value),
      ),
    );
  }

  Future<void> _processSuccess() async {
    final paymentApp =
        _selectedUpiAppIndex != null
            ? _apps![_selectedUpiAppIndex!].upiApplication.getAppName()
            : 'UPI';
    final receipt = await generateReceipt(
      context,
      ref,
      transaction.rawResponse!,
      paymentApp,
    );
    await ref.read(receiptProvider.notifier).saveReceipt(receipt);
    navigateNextAndClean(context, ref, receipt);
  }
}
