import 'package:app_for_arudino_vehicle/bloc/bloc.dart';
import 'package:app_for_arudino_vehicle/pages/drive_page/drive_page.dart';
import 'package:app_for_arudino_vehicle/pages/main_page/widgets/discoverity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    FlutterBluetoothSerial.instance.isEnabled.then((isEnabled) {
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
              ),
              BlocBuilder<ConnectedDeviceBloc, ConnectedDeviceState>(
                builder: (context, state) {
                  if (state is InitialConnectedDeviceState) {
                    return Container(
                      child: Text('None device is connected'),
                    );
                  } else if (state is ConnectingToDevice) {
                    return Container(
                      child: Row(
                        children: <Widget>[
                          Text('Connecting to device...'),
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  } else if (state is ConnectedToDevice) {
                    String deviceAddress = state.device.address;
                    String deviceName = state.device.name;
                    return Container(
                      child: Column(
                        children: <Widget>[
                          Text(
                              'Connected to device: $deviceName address: $deviceAddress'),
                          RaisedButton(
                            child: Text('Drive the vehicle'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DrivePage(),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    );
                  } else if (state is ErrorDuringConnecting) {
                    return Container(
                      child: Text('During connecting occured an error!'),
                    );
                  }

                  return Container(
                    child: Text('This should not be shown'),
                  );
                },
              ),
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
