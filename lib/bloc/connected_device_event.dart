import 'package:equatable/equatable.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConnectedDeviceEvent extends Equatable {
  ConnectedDeviceEvent([List props = const <dynamic>[]]) : super(props);
}

class ConnectToDevice extends ConnectedDeviceEvent {
  final BluetoothDevice device;

  ConnectToDevice({@required this.device}) : super([device]);
}