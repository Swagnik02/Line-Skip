import 'package:flutter/material.dart';
import 'package:line_skip/data/models/receipt_model.dart';
import 'package:line_skip/widgets/custom_app_bar.dart';

class ViewReceiptPage extends StatelessWidget {
  final ReceiptModel receipt;
  const ViewReceiptPage({
    super.key,
    required this.receipt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ''),
      body: Center(
        child: Text('Receipt Details'),
      ),
    );
  }
}
