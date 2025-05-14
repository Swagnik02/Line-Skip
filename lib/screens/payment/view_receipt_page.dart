import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_skip/data/models/item_model.dart';
import 'package:line_skip/data/models/receipt_model.dart';
import 'package:line_skip/widgets/line_skip_text.dart';

class ViewReceiptPage extends StatelessWidget {
  final ReceiptModel receipt;
  const ViewReceiptPage({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('dd-MM-yyyy').format(receipt.createdAt);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // header
                  _buildSection(
                    Column(
                      children: [
                        lineSkip1("Line Skip"),
                        const SizedBox(height: 8),
                        const Text(
                          "AzApps",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  // Thanks Giving
                  _buildSection(
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
                            Spacer(),
                            _iconRow(Icons.phone, receipt.user.phoneNumber),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Store and Owner Details
                  _buildSection(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [_buildStoreDetails(), _buildOwnerDetails()],
                    ),
                  ),
                  // Total Amount and Date
                  _buildSection(
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
                            Text(dateFormatted),
                            const SizedBox(height: 4),
                            Text(
                              "Qty: ${receipt.items.length}",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Invoice ID
                  _buildAltSection(
                    Row(
                      children: [
                        const Text("Invoice ", style: boldStyle),
                        Text("#${receipt.receiptId}"),
                      ],
                    ),
                  ),
                  // Item List
                  _buildItemSection([
                    ...receipt.items.asMap().entries.map(
                      (entry) => _buildItemTile(entry.value, entry.key),
                    ),
                    _buildItemTileContainer('   ', [
                      _buildRowItemList(
                        'Total Amount',
                        '₹ ${receipt.invoiceTotal.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 4),
                      _buildRowItemList(
                        receipt.transactionDetails.upiApplication,
                        receipt.transactionDetails.transactionId,
                      ),
                    ]),
                  ]),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
                color: Colors.white,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Colors.deepOrangeAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FilledButton(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.deepOrangeAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onPressed: () {
            // Handle invoice download
          },
          child: const Text("Download Invoice"),
        ),
      ),
    );
  }

  static const boldStyle = TextStyle(fontWeight: FontWeight.bold);

  Widget _buildStoreDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _iconRow(Icons.store, receipt.store.name, fontSize: 16),
        const SizedBox(height: 4),
        _iconRow(
          Icons.location_on_rounded,
          receipt.store.location,
          fontSize: 14,
        ),
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

  Widget _iconRow(IconData icon, String text, {double fontSize = 14}) {
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: fontSize)),
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

  Container _buildSection(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Container _buildAltSection(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      width: double.infinity,
      child: child,
    );
  }

  Widget _buildItemSection(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}
