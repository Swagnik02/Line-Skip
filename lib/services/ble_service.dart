import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;

  Future<void> connectToDevice({
    required BluetoothDevice device,
    required void Function(String data) onDataReceived,
    void Function()? onDisconnected,
  }) async {
    await device.connect(autoConnect: false);

    _connectionSubscription = device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected) {
        onDisconnected?.call();
      }
    });

    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          await characteristic.setNotifyValue(true);
          characteristic.lastValueStream.listen((value) {
            final data = String.fromCharCodes(value);
            onDataReceived(data);
          });
        }
      }
    }
  }

  Future<void> disconnectDevice(BluetoothDevice? device) async {
    await device?.disconnect();
    await _connectionSubscription?.cancel();
  }
}
