import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/providers/ble_provider.dart';
import 'package:line_skip/screens/store/store_page.dart';
import 'package:line_skip/widgets/confirmation_dialog.dart';
import 'package:line_skip/widgets/custom_app_bar.dart';

class TrolleyPairingPage extends ConsumerStatefulWidget {
  const TrolleyPairingPage({super.key});

  @override
  ConsumerState<TrolleyPairingPage> createState() => _TrolleyPairingPageState();
}

class _TrolleyPairingPageState extends ConsumerState<TrolleyPairingPage> {
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    FlutterBluePlus.turnOn();
    _startScan();
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  // Start scanning and update scanning status
  void _startScan() {
    setState(() {
      isScanning = true;
    });

    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

    // Stop scanning after the timeout and update the state
    Future.delayed(Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          isScanning = false;
        });
      }
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    final shouldConnect = await showConfirmationDialog(
      context: context,
      title: "Trolley Pairing",
      message:
          "Are you sure you want to pair with ${device.localName.isNotEmpty ? device.localName : 'Unknown'}?",
      cancelText: "Cancel",
      confirmText: "Yes",
      icon: Icons.bluetooth_connected,
      cancelColor: Colors.deepOrange,
      confirmColor: Colors.red,
    );

    if (shouldConnect != true) return;

    try {
      await FlutterBluePlus.stopScan();

      // ✅ Update Riverpod provider here
      await ref.read(bleProvider.notifier).connectToDevice(device);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const StorePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connection failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Trolley Pairing",
      ),
      body: StreamBuilder<List<ScanResult>>(
        stream: FlutterBluePlus.scanResults,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final devices = snapshot.data!;
          if (devices.isEmpty) {
            return Center(
              child: Text("No BLE devices found",
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }

          // Sort devices by RSSI in descending order
          devices.sort((a, b) => b.rssi.compareTo(a.rssi));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: devices.map<Widget>((result) {
              final device = result.device;
              final name = device.platformName.isNotEmpty
                  ? device.platformName
                  : result.advertisementData.localName.isNotEmpty
                      ? result.advertisementData.localName
                      : "Unknown Device";
              final rssi = result.rssi;

              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Icon(
                  Icons.bluetooth,
                  color: Colors.deepOrangeAccent,
                  size: 28,
                ),
                title: Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                subtitle: Text(
                  device.remoteId.str,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                trailing: Text(
                  "$rssi dBm",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: rssi > -60
                        ? Colors.green
                        : Colors.red, // Color based on RSSI value
                  ),
                ),
                onTap: () async => await _connectToDevice(device),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: isScanning
            ? CircularProgressIndicator(color: Colors.white)
            : FloatingActionButton(
                onPressed: () {
                  _startScan();
                },
                backgroundColor: Colors.deepOrangeAccent,
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
