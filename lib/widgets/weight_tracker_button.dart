import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/providers/ble_provider.dart';

GestureDetector weightTrackerButton(WidgetRef ref, BuildContext context) {
  return GestureDetector(
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
    // Calling the independent function to show the dialog
    _showDeviceDialog(context, ref);
  }
}

// Independent function to show the dialog
void _showDeviceDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (_) {
      return Consumer(
        builder: (context, ref, child) {
          final bleState = ref.watch(bleProvider);
          return AlertDialog(
            title: Text("Connected Device"),
            content: Text("Received Data: ${bleState.receivedData}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    },
  );
}
