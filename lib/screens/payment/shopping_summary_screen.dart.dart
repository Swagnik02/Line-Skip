import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_skip/data/models/item_model.dart';
import 'package:line_skip/data/models/receipt_model.dart';
import 'package:line_skip/widgets/line_skip_text.dart';

class ShoppingSummaryScreen extends StatelessWidget {
  final ReceiptModel receipt;

  const ShoppingSummaryScreen({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('dd MMM yyyy').format(receipt.createdAt);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  _buildCard(
                    Column(
                      children: [
                        lineSkip1("Line Skip"),
                        const SizedBox(height: 6),
                        const Text(
                          "AzApps",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),

                  // Thank you and customer info
                  _buildCard(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Thank you for shopping via LineSkip.",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(receipt.user.name, style: boldStyle),
                            const Spacer(),
                            _iconRow(Icons.phone, receipt.user.phoneNumber),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Store & Owner details
                  _buildCard(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [_buildStoreDetails(), _buildOwnerDetails()],
                    ),
                  ),

                  // Amount & Date
                  _buildCard(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Amount Paid",
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              "₹${receipt.invoiceTotal.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              dateFormatted,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Qty: ${receipt.items.length}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Invoice ID
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        const Text("Invoice ", style: boldStyle),
                        Text("#${receipt.receiptId}"),
                      ],
                    ),
                  ),

                  // Item List
                  _buildCard(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var entry in receipt.items.asMap().entries)
                          _buildItemTile(entry.value, entry.key),
                        const Divider(thickness: 0.8),
                        _buildSummary(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Close button
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                backgroundColor: Colors.deepOrangeAccent,
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const boldStyle = TextStyle(fontWeight: FontWeight.bold);

  Widget _iconRow(IconData icon, String text, {double fontSize = 14}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.deepOrangeAccent),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: fontSize)),
      ],
    );
  }

  Widget _buildStoreDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _iconRow(Icons.store, receipt.store.name, fontSize: 16),
        const SizedBox(height: 4),
        _iconRow(Icons.location_on, receipt.store.location, fontSize: 14),
      ],
    );
  }

  Widget _buildOwnerDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _iconRow(Icons.person, receipt.store.ownerName, fontSize: 16),
        const SizedBox(height: 4),
        _iconRow(Icons.phone, receipt.store.mobileNumber, fontSize: 14),
      ],
    );
  }

  Widget _buildItemTile(Item item, int index) {
    final itemTotal = item.price + item.tax;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItemTileContainer('${index + 1}.', [
          _buildRowItemList(item.name, '₹ ${item.price.toStringAsFixed(2)}'),
          _buildRowItemList('Tax', '+ ₹ ${item.tax.toStringAsFixed(2)}'),
          const SizedBox(height: 4),
          _buildRowItemList('Net Amount', '₹ ${itemTotal.toStringAsFixed(2)}'),
        ]),
        const Divider(thickness: 0.5),
      ],
    );
  }

  Row _buildRowItemList(String left, String right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(left, style: boldStyle), Text(right, style: boldStyle)],
    );
  }

  Widget _buildItemTileContainer(String index, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(index, style: boldStyle),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _rowLine("Total Amount", "₹${receipt.invoiceTotal.toStringAsFixed(2)}"),
        const SizedBox(height: 4),
        _rowLine(
          receipt.transactionDetails.upiApplication,
          receipt.transactionDetails.transactionId,
        ),
      ],
    );
  }

  Widget _rowLine(String left, String right, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: TextStyle(
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            right,
            style: TextStyle(
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
