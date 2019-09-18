import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConnectedDeviceState extends Equatable {
  ConnectedDeviceState([List props = const <dynamic>[]]) : super(props);
}

class InitialConnectedDeviceState extends ConnectedDeviceState {}

class ConnectingToDevice extends ConnectedDeviceState {}

class ConnectedToDevice extends ConnectedDeviceState {
  final BluetoothConnection bluetoothConnection;
  final BluetoothDevice device;

  ConnectedToDevice({@required this.bluetoothConnection, @required this.device})
      : super([bluetoothConnection, device]);
}

class ErrorDuringConnecting extends ConnectedDeviceState {}

class Disconnected extends ConnectedDeviceState {}