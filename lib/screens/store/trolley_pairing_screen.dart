import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/providers/ble_provider.dart';
import 'package:line_skip/screens/store/store_page.dart';

class TrolleyPairingPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<TrolleyPairingPage> createState() => _TrolleyPairingPageState();
}

class _TrolleyPairingPageState extends ConsumerState<TrolleyPairingPage> {
  @override
  void initState() {
    super.initState();
    FlutterBluePlus.turnOn();
    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    final shouldConnect = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Connect to Device'),
        content: Text(
            'Are you sure you want to connect to ${device.localName.isNotEmpty ? device.localName : 'Unknown'}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Connect')),
        ],
      ),
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
    // final bleState = ref.watch(bleProvider);
    // if (bleState.connectedDevice != null) {
    //   return const StorePage();
    // }
    return Scaffold(
      appBar: AppBar(title: Text('Pair Trolley')),
      body: StreamBuilder<List<ScanResult>>(
        stream: FlutterBluePlus.scanResults,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final devices = snapshot.data!;
          if (devices.isEmpty) {
            return Center(child: Text("No BLE devices found"));
          }

          return ListView(
            children: devices.map((result) {
              final device = result.device;
              final name = device.platformName.isNotEmpty
                  ? device.platformName
                  : result.advertisementData.localName.isNotEmpty
                      ? result.advertisementData.localName
                      : "Unknown Device";

              return ListTile(
                title: Text(name),
                subtitle: Text(device.remoteId.str),
                onTap: () async => await _connectToDevice(device),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            FlutterBluePlus.startScan(timeout: Duration(seconds: 4)),
        child: Icon(Icons.refresh),
      ),
    );
  }
}
