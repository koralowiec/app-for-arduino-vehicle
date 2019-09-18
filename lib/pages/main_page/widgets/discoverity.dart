import 'package:app_for_arudino_vehicle/bloc/bloc.dart';
import 'package:app_for_arudino_vehicle/constants/text.dart';
import 'package:app_for_arudino_vehicle/pages/main_page/widgets/device_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Discoverity extends StatefulWidget {
  @override
  _DiscoverityState createState() => _DiscoverityState();
}

class _DiscoverityState extends State<Discoverity> {
  bool areDiscoveredDevicesShown = false;
  bool isDiscovering = false;
  List<BluetoothDiscoveryResult> discoveryResults =
      List<BluetoothDiscoveryResult>();
  String connectedDeviceAddress = '';
  BluetoothConnection connection;
  bool isConnecting = false;

  _discoverDevices() async {
    setState(() {
      discoveryResults.clear();
    });

    FlutterBluetoothSerial.instance.startDiscovery().listen((data) {
      discoveryResults.add(data);
      setState(() {});
      print(discoveryResults.length.toString());
    }, onDone: () {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  disconnectWithDevice() {
    if (connection != null) {
      BlocProvider.of<ConnectedDeviceBloc>(context).dispatch(
        DisconnectWithDevice(connection: connection),
      );
    }
    setState(() {
      connectedDeviceAddress = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectedDeviceBloc, ConnectedDeviceState>(
      listener: (context, state) {
        if (state is ConnectedToDevice) {
          setState(() {
            connectedDeviceAddress = state.device.address;
            connection = state.bluetoothConnection;
            isConnecting = false;
          });
          print('Connected to $connectedDeviceAddress');
        } else if (state is ConnectingToDevice) {
          setState(() {
            isConnecting = true;
          });
        }
      },
      child: Column(
        children: <Widget>[
          ListTile(
            title: RaisedButton(
              child: Text(
                  areDiscoveredDevicesShown ? hideDiscovered : showDiscovered),
              onPressed: () {
                setState(() {
                  areDiscoveredDevicesShown = !areDiscoveredDevicesShown;
                  isDiscovering = areDiscoveredDevicesShown ? true : false;
                });
                if (isDiscovering) {
                  _discoverDevices();
                }
              },
            ),
          ),
          Container(
            height: 250.0,
            child: ListView.builder(
              itemCount: discoveryResults.length,
              itemBuilder: (BuildContext context, int index) {
                BluetoothDiscoveryResult foundDevice = discoveryResults[index];
                return DeviceItem(
                  bluetoothDevice: foundDevice.device,
                  isConnected:
                      foundDevice.device.address == connectedDeviceAddress,
                  onDisconnect: disconnectWithDevice,
                  shouldBePressingConnectBlocked: isConnecting,
                );
              },
            ),
          ),
          Visibility(
            visible: isDiscovering,
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
