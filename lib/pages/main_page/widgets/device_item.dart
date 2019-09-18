import 'package:app_for_arudino_vehicle/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DeviceItem extends StatelessWidget {
  final BluetoothDevice bluetoothDevice;
  final bool isConnected;
  final Function onDisconnect;
  final bool shouldBePressingConnectBlocked;

  const DeviceItem(
      {@required this.bluetoothDevice,
      @required this.isConnected,
      @required this.onDisconnect,
      @required this.shouldBePressingConnectBlocked});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Name: ' + bluetoothDevice.name,
                ),
                Text(
                  'Address: ' + bluetoothDevice.address,
                ),
              ],
            ),
            Visibility(
              visible: !bluetoothDevice.isBonded,
              child: RaisedButton(
                child: Text('Pair'),
                onPressed: () async {
                  print('Pair pressed');
                  bool paired = await FlutterBluetoothSerial.instance
                      .bondDeviceAtAddress(bluetoothDevice.address);
                  print('paired ' + paired.toString());
                },
              ),
            ),
            Visibility(
              visible: !isConnected && bluetoothDevice.isBonded,
              child: RaisedButton(
                child: Text('Connect'),
                onPressed: () async {
                  if (!shouldBePressingConnectBlocked) {
                    final bloc = BlocProvider.of<ConnectedDeviceBloc>(context);
                    bloc.dispatch(ConnectToDevice(device: bluetoothDevice));
                  }
                },
              ),
            ),
            Visibility(
              visible: isConnected,
              child: RaisedButton(
                child: Text('Disconnect'),
                onPressed: () async {
                  onDisconnect();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
