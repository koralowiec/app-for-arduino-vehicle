import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import './bloc.dart';

class ConnectedDeviceBloc
    extends Bloc<ConnectedDeviceEvent, ConnectedDeviceState> {
  @override
  ConnectedDeviceState get initialState => InitialConnectedDeviceState();

  @override
  Stream<ConnectedDeviceState> mapEventToState(
    ConnectedDeviceEvent event,
  ) async* {
    if (event is ConnectToDevice) {
      yield ConnectingToDevice();
      BluetoothConnection bluetoothConnection;
      try {
        bluetoothConnection =
            await BluetoothConnection.toAddress(event.device.address);
      } catch (e) {
        print(e.toString());
        yield ErrorDuringConnecting();
      }

      yield ConnectedToDevice(
        bluetoothConnection: bluetoothConnection,
        device: event.device,
      );
    } else if (event is DisconnectWithDevice) {
      event.connection.finish();
      yield Disconnected();
    }
  }
}
