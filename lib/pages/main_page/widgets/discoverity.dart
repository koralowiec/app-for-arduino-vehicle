import 'package:app_for_arudino_vehicle/constants/text.dart';
import 'package:app_for_arudino_vehicle/pages/main_page/widgets/device_item.dart';
import 'package:flutter/material.dart';
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

  _discoverDevices() async {
    List<BluetoothDiscoveryResult> resultsFromStream =
        await FlutterBluetoothSerial.instance.startDiscovery().toList();
    setState(() {
      discoveryResults = resultsFromStream;
      isDiscovering = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Visibility(
          visible: !isDiscovering,
          child: Container(
            height: 300.0,
            child: ListView.builder(
              itemCount: discoveryResults.length,
              itemBuilder: (BuildContext context, int index) {
                BluetoothDiscoveryResult foundDevice = discoveryResults[index];
                return DeviceItem(
                  deviceName: foundDevice.device.name,
                );
              },
            ),
          ),
        ),
        Visibility(
          visible: isDiscovering,
          child: CircularProgressIndicator(),
        )
      ],
    );
  }
}
