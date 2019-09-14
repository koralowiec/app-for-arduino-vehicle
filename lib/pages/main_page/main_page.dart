import 'package:app_for_arudino_vehicle/pages/main_page/widgets/discoverity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isBluetoothEnabled = false;
  bool areDiscoveredDevicesShown = false;

  @override
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance.isEnabled.then((isEnabled){
      setState(() {
        isBluetoothEnabled = isEnabled;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            SwitchListTile(
              title: Text('Enable Bluetooth'),
              onChanged: onEnableBluetoothChange,
              value: isBluetoothEnabled,
            ),
            Divider(),
            Visibility(
              visible: isBluetoothEnabled,
              child: Discoverity(),
            )
          ],
        ),
      ),
    );
  }

  onEnableBluetoothChange(value) async {
    FlutterBluetoothSerial flutterBluetoothSerial =
        FlutterBluetoothSerial.instance;
    if (value) {
      await flutterBluetoothSerial.requestEnable();
    } else {
      await flutterBluetoothSerial.requestDisable();
    }

    bool isEnabled = await flutterBluetoothSerial.isEnabled;
    setState(() {
      isBluetoothEnabled = isEnabled;
    });
  }
}
