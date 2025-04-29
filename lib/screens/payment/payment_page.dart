import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/providers/cart_provider.dart';
import 'package:line_skip/providers/store_provider.dart';
import 'package:upi_pay/upi_pay.dart';

enum PaymentMethod {
  Card,
  GooglePay,
  AmazonPay,
  UPI,
}

class PaymentPage extends ConsumerStatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  PaymentMethod? _selectedPaymentMethod = PaymentMethod.Card;
  String? _upiAddrError;
  final _upiPayPlugin = UpiPay();
  List<ApplicationMeta>? _apps;

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

  String? _validateUpiAddress(String value) {
    if (value.isEmpty) {
      return 'UPI VPA is required.';
    }
    if (value.split('@').length != 2) {
      return 'Invalid UPI VPA';
    }
    return null;
  }

  Future<void> _onTapUPI(ApplicationMeta app) async {
    final selectedStore = ref.watch(selectedStoreProvider);
    final cartNotifier = ref.read(cartItemsProvider.notifier);

    final err = _validateUpiAddress(selectedStore!.storeUpiId);
    if (err != null) {
      setState(() {
        _upiAddrError = err;
      });
      return;
    }
    setState(() {
      _upiAddrError = null;
    });

    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    print("Starting transaction with id $transactionRef");

    final transaction = await _upiPayPlugin.initiateTransaction(
      amount: '10',
      app: app.upiApplication,
      receiverName: selectedStore.name,
      receiverUpiAddress: selectedStore.storeUpiId,
      transactionRef: transactionRef,
      transactionNote: 'Line Skip Payment',
    );

    print(transaction);
  }

  void _onPayPressed() {
    switch (_selectedPaymentMethod) {
      case PaymentMethod.Card:
        // Handle Card payment flow
        print('Card payment selected');
        break;
      case PaymentMethod.GooglePay:
        // Handle Google Pay flow
        print('Google Pay selected');
        break;
      case PaymentMethod.AmazonPay:
        // Handle Amazon Pay flow
        print('Amazon Pay selected');
        break;
      case PaymentMethod.UPI:
        // Ask user to select a UPI app
        showModalBottomSheet(
          context: context,
          builder: (_) => _buildUpiAppsSheet(),
        );
        break;
      default:
        break;
    }
  }

  Widget _buildUpiAppsSheet() {
    return _apps == null
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _apps!.length,
            itemBuilder: (context, index) {
              final app = _apps![index];
              return InkWell(
                onTap: () async {
                  Navigator.pop(context);
                  await _onTapUPI(app);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    app.iconImage(48),
                    SizedBox(height: 8),
                    Text(
                      app.upiApplication.getAppName(),
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    final cartNotifier = ref.watch(cartItemsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Payment Options')),
      body: Padding(
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 12),

                  // Card Option
                  ListTile(
                    leading: Icon(Icons.credit_card),
                    title: Text('Flipkart Axis Card'),
                    subtitle: Text('Additional ₹14 cashback'),
                    trailing: Radio<PaymentMethod>(
                      value: PaymentMethod.Card,
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value;
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
                        });
                      },
                    ),
                  ),
                  Divider(),

                  // Amazon Pay
                  ListTile(
                    leading: Icon(Icons.account_balance),
                    title: Text('Amazon Pay Balance'),
                    trailing: Radio<PaymentMethod>(
                      value: PaymentMethod.AmazonPay,
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value;
                        });
                      },
                    ),
                  ),
                  Divider(),

                  // UPI Option
                  ListTile(
                    leading: Icon(Icons.send),
                    title: Text('Pay via UPI App'),
                    trailing: Radio<PaymentMethod>(
                      value: PaymentMethod.UPI,
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Pay Button
            SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onPayPressed,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Pay ₹${cartNotifier.calculateTotalPrice()}'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
