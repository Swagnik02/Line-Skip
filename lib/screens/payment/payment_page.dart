import 'dart:math';
import 'dart:developer' as dev show log;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/providers/cart_provider.dart';
import 'package:line_skip/providers/store_provider.dart';
import 'package:line_skip/screens/payment/payment_verification_laoder.dart';
import 'package:line_skip/utils/payment_helpers.dart';
import 'package:line_skip/utils/payment_success.dart';
import 'package:line_skip/widgets/custom_app_bar.dart';
import 'package:line_skip/widgets/custom_elevated_button.dart';
import 'package:upi_pay/upi_pay.dart';

bool kDemoMode = true;

enum PaymentMethod {
  Card,
  GooglePay,
  UPI,
}

class PaymentPage extends ConsumerStatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  PaymentMethod? _selectedPaymentMethod = PaymentMethod.Card;
  int? _selectedUpiAppIndex;
  String? _upiAddrError;
  final _upiPayPlugin = UpiPay();
  List<ApplicationMeta>? _apps;
  late UpiTransactionResponse transaction;

  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    _fetchUpiApps();
  }

  Future<void> _fetchUpiApps() async {
    _apps = await _upiPayPlugin.getInstalledUpiApplications(
      statusType: UpiApplicationDiscoveryAppStatusType.all,
    );
    setState(() {});
  }

  Future<void> _onTapUPI(ApplicationMeta app) async {
    final selectedStore = ref.watch(selectedStoreProvider);
    final cartNotifier = ref.read(cartItemsProvider.notifier);

    final err = validateUpiAddress(selectedStore!.storeUpiId);
    if (err != null) {
      setState(() {
        _upiAddrError = err;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    setState(() {
      _upiAddrError = null;
      _isProcessingPayment = true;
    });

    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    dev.log("Starting transaction with id $transactionRef");

    try {
      transaction = await _upiPayPlugin.initiateTransaction(
        amount: cartNotifier.calculateTotalPrice().toString(),
        app: app.upiApplication,
        receiverName: selectedStore.name,
        receiverUpiAddress: selectedStore.storeUpiId,
        transactionRef: transactionRef,
        transactionNote: 'Line Skip Payment',
      );

      dev.log(transaction.toString(), name: 'UPI Transaction');

      if (kDemoMode) {
        await Future.delayed(Duration(seconds: 2));
        transaction =
            manipulateResponse(transaction.rawResponse!, transactionRef);
        dev.log(transaction.toString(), name: 'Manipulated Response');
      }

      if (transaction.status == UpiTransactionStatus.success) {
        _success();

        _showSnackBar('Transaction successful.');
      } else {
        _showErrorSnackBar('Transaction failed or cancelled.');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred during transaction.');
    } finally {
      setState(() {
        _isProcessingPayment = false;
      });
    }
  }

  void _onPayPressed() async {
    try {
      switch (_selectedPaymentMethod) {
        case PaymentMethod.Card:
          _showErrorSnackBar('Card payment is not implemented.');
          break;

        case PaymentMethod.GooglePay:
          final googlePayApp = _apps?.firstWhere(
            (app) => app.upiApplication == UpiApplication.googlePay,
          );

          if (googlePayApp != null) {
            await _onTapUPI(googlePayApp);
          } else {
            _showErrorSnackBar('Google Pay is not installed on this device.');
          }
          break;

        case PaymentMethod.UPI:
          if (_selectedUpiAppIndex != null &&
              _apps != null &&
              _apps!.isNotEmpty) {
            await _onTapUPI(_apps![_selectedUpiAppIndex!]);
          } else {
            _showErrorSnackBar('Please select a UPI app to continue.');
          }
          break;

        default:
          _showErrorSnackBar('Please select a payment method.');
      }
    } catch (e) {
      _showErrorSnackBar('An unexpected error occurred: $e');
      setState(() {
        _isProcessingPayment = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartNotifier = ref.watch(cartItemsProvider.notifier);

    return Scaffold(
      appBar: CustomAppBar(title: 'Payment Options'),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 12),

                      // Card Option
                      ListTile(
                        leading: Icon(Icons.credit_card),
                        title: Text('Card Payment'),
                        trailing: Radio<PaymentMethod>(
                          value: PaymentMethod.Card,
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value;
                              _selectedUpiAppIndex = null;
                            });
                          },
                        ),
                      ),
                      Divider(),

                      // Google Pay
                      ListTile(
                        leading: Icon(Icons.account_balance_wallet),
                        title: Text('Google Pay'),
                        trailing: Radio<PaymentMethod>(
                          value: PaymentMethod.GooglePay,
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value;
                              _selectedUpiAppIndex = null;
                            });
                          },
                        ),
                      ),
                      Divider(),

                      // Section: Available UPI Apps
                      if (_apps != null && _apps!.isNotEmpty) ...[
                        SizedBox(height: 24),
                        Text(
                          'Available UPI Apps',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
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
                                      _selectedPaymentMethod = null;
                                      _selectedUpiAppIndex = value;
                                      _selectedPaymentMethod =
                                          PaymentMethod.UPI;
                                    });
                                  },
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        }),
                      ],
                    ],
                  ),
                ),

                // Pay Button
                CustomElevatedButton(
                  title: 'Pay ₹${cartNotifier.calculateTotalPrice()}',
                  onPressed: kDebugMode ? _simulatePayment : _onPayPressed,
                ),
              ],
            ),
          ),
          if (_isProcessingPayment) VerificationLoader(),
        ],
      ),
    );
  }

  Future<void> _simulatePayment() async {
    setState(() {
      _isProcessingPayment = true;
    });

    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    dev.log("Starting transaction with id $transactionRef");

    try {
      transaction = simulateSuccessTransactionResponse(transactionRef);

      dev.log(transaction.toString(), name: 'UPI Transaction');

      await Future.delayed(Duration(seconds: 2));

      if (transaction.status == UpiTransactionStatus.success) {
        _success();
        _showSnackBar('Transaction successful.');
      } else {
        _showErrorSnackBar('Transaction failed or cancelled.');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred during transaction.');
    } finally {
      setState(() {
        _isProcessingPayment = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _success() {
    final paymentApp = '';
    success(
      context,
      ref,
      transaction.rawResponse!,
      paymentApp,
    );
  }
}
