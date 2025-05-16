import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/providers/ble_provider.dart';
import 'package:line_skip/providers/cart_provider.dart';

InkWell weightTrackerButton(WidgetRef ref, BuildContext context) {
  return InkWell(
    borderRadius: BorderRadius.circular(8.0),
    splashColor: Colors.deepOrangeAccent.shade100.withOpacity(0.2),
    onTap: () => _openWeightTracker(context, ref),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade700, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade200,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.scale_sharp, color: Colors.green.shade900, size: 28),
        ],
      ),
    ),
  );
}

void _openWeightTracker(BuildContext context, WidgetRef ref) {
  final bleState = ref.watch(bleProvider);

  if (bleState.connectedDevice != null) {
    showDeviceDialog(context, ref);
  }
}

Future<void> showDeviceDialog(BuildContext context, WidgetRef ref) {
  return showDialog(
    context: context,
    builder: (_) {
      return Consumer(
        builder: (context, ref, child) {
          final cartNotifier = ref.read(cartItemsProvider.notifier);
          final bleState = ref.watch(bleProvider);

          final expectedWeight = cartNotifier.calculateTotalWeight();
          final actualWeight = bleState.receivedData;
          final isWeightMatching = cartNotifier.validateWeight(actualWeight);

          return PopScope(
            canPop: isWeightMatching,
            child: AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.scale, color: Colors.deepOrange),
                      SizedBox(width: 10),
                      Text(
                        "Trolley Weight Info",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    bleState.connectedDevice?.name ?? "Unknown Device",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(thickness: 1),
                  _infoCard(
                    icon: Icons.speed,
                    label: "Expected Weight",
                    value: "$expectedWeight g",
                    bgColor: Colors.orange.shade50,
                  ),
                  const SizedBox(height: 12),
                  _infoCard(
                    icon: Icons.monitor_weight,
                    label: "Actual Trolley Weight",
                    value: "$actualWeight g",
                    bgColor:
                        isWeightMatching
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                  ),
                  if (!isWeightMatching) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.red,
                            size: 24,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Mismatch detected! The actual trolley weight doesn't match the expected weight of scanned items. \n Kindly put exact items in the trolley in order to continue shopping !!.",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                if (isWeightMatching)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "CLOSE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _infoCard({
  required IconData icon,
  required String label,
  required String value,
  Color? bgColor,
}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: bgColor ?? Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.grey[800], size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
