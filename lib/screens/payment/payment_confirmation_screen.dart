import 'package:flutter/material.dart';
import 'package:line_skip/data/models/receipt_model.dart';
import 'package:line_skip/screens/payment/shopping_summary_screen.dart.dart';
import 'package:line_skip/utils/helpers.dart';
import 'package:line_skip/widgets/payment_confirmation_widgets.dart';
import 'package:line_skip/widgets/custom_app_bar.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final ReceiptModel receipt;
  const PaymentConfirmationScreen({super.key, required this.receipt});

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _cardController;
  late AnimationController _buttonController;

  late Animation<double> _pulseAnimation;
  late Animation<Offset> _circleSlideAnimation;
  late Animation<Offset> _cardSlideAnimation;
  late Animation<double> _cardFadeAnimation;
  late Animation<double> _buttonFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Circle animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutBack),
    );
    _circleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));

    // Card animation
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _cardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOut));
    _cardFadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_cardController);

    // Button animation
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _buttonFadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_buttonController);

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await _pulseController.forward();
    await _cardController.forward();
    await _buttonController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _cardController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double circleRadius = 50.0;

    return Scaffold(
      appBar: CustomAppBar(title: 'Payment Confirmation'),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 35.0,
            right: 35.0,
            top: 25,
            bottom: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  double spacingFromTop = circleRadius;

                  return Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      // Animated Payment Card
                      SlideTransition(
                        position: _cardSlideAnimation,
                        child: FadeTransition(
                          opacity: _cardFadeAnimation,
                          child: _paymentDetailsCard(
                            spacingFromTop,
                            circleRadius,
                          ),
                        ),
                      ),

                      // Animated Tick Circle
                      SlideTransition(
                        position: _circleSlideAnimation,
                        child: ScaleTransition(
                          scale: _pulseAnimation,
                          child: _circularTick(circleRadius),
                        ),
                      ),
                    ],
                  );
                },
              ),

              // Animated Buttons
              FadeTransition(opacity: _buttonFadeAnimation, child: _footer()),
            ],
          ),
        ),
      ),
    );
  }

  Column _footer() {
    return Column(
      children: [
        buildButton(
          label: "Billing Overview",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ShoppingSummaryScreen(receipt: widget.receipt),
              ),
            );
          },
          backgroundColor: Colors.white,
          textColor: Colors.black54,
          outlined: true,
        ),
        const SizedBox(height: 12),
        buildButton(
          label: "Back to HomeScreen",
          onPressed: () => Navigator.pop(context),
          backgroundColor: Colors.deepOrangeAccent,
          textColor: Colors.white,
        ),
      ],
    );
  }

  Positioned _circularTick(double circleRadius) {
    return Positioned(
      top: 0,
      child: Container(
        width: circleRadius * 2,
        height: circleRadius * 2,
        decoration: const BoxDecoration(
          color: Colors.deepOrangeAccent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: const Icon(Icons.check_rounded, size: 60, color: Colors.white),
      ),
    );
  }

  Container _paymentDetailsCard(double spacingFromTop, double circleRadius) {
    final receipt = widget.receipt;
    final formattedDate = formatReceiptDate(receipt.createdAt);

    return Container(
      margin: EdgeInsets.only(top: spacingFromTop),
      padding: EdgeInsets.only(
        top: circleRadius + 30,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Payment Total",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black26,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            receipt.paymentDetails.invoiceTotal.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 16),
          buildRow('Date', formattedDate),
          buildRow('Details', 'Residential'),
          buildRow('Txn num', receipt.transactionId),
          buildRow('Account', receipt.transactionDetails.receiverName),
          const Divider(height: 32),
          buildRow('Net Amount', receipt.paymentDetails.netAmount.toString()),
          buildRow('Tax', receipt.paymentDetails.taxAmount.toString()),
          buildRow(
            'Invoice Total',
            receipt.paymentDetails.invoiceTotal.toString(),
          ),
        ],
      ),
    );
  }
}
