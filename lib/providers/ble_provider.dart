import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/services/ble_service.dart';

class BLEState {
  final BluetoothDevice? connectedDevice;
  final double receivedData;
  final String deviceName;

  BLEState({
    this.connectedDevice,
    this.receivedData = 0.0,
    this.deviceName = '',
  });

  BLEState copyWith({
    BluetoothDevice? connectedDevice,
    double? receivedData,
    String? deviceName,
  }) {
    return BLEState(
      connectedDevice: connectedDevice ?? this.connectedDevice,
      receivedData: receivedData ?? this.receivedData,
      deviceName: deviceName ?? this.deviceName,
    );
  }
}

class BLENotifier extends StateNotifier<BLEState> {
  final BleService bleService;

  BLENotifier(this.bleService) : super(BLEState());
  Future<void> connectToDevice(BluetoothDevice device) async {
    state = state.copyWith(
      connectedDevice: device,
      deviceName: device.localName,
    );

    await bleService.connectToDevice(
      device: device,
      onDataReceived: (data) {
        final parsed = double.tryParse(data.toString()) ?? 0.0;
        state = state.copyWith(receivedData: parsed);
      },
    );
  }

  Future<void> disconnect() async {
    await bleService.disconnectDevice(state.connectedDevice);
    state = BLEState();
  }
}

final bleServiceProvider = Provider<BleService>((ref) => BleService());

final bleProvider = StateNotifierProvider<BLENotifier, BLEState>(
  (ref) => BLENotifier(ref.read(bleServiceProvider)),
);
