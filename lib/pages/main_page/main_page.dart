import 'package:app_for_arudino_vehicle/bloc/bloc.dart';
import 'package:app_for_arudino_vehicle/pages/drive_with_buttons/drive_page.dart';
import 'package:app_for_arudino_vehicle/pages/drive_with_sensors/drive_with_sensors_page.dart';
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
  BluetoothConnection _connection;

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
  void dispose() {
    print('dispose()');
    print('Connection: ${_connection.toString()}');
    _connection.finish();
    print('Is connected: ${_connection.isConnected}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ConnectedDeviceBloc, ConnectedDeviceState>(
        listener: (context, state) {
          if (state is ConnectedToDevice) {
            setState(() {
              _connection = state.bluetoothConnection;
            });
          }
        },
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 4,
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
                  ],
                ),
              ),
              Divider(),
              Expanded(
                flex: 1,
                child: BlocBuilder<ConnectedDeviceBloc, ConnectedDeviceState>(
                  builder: (context, state) {
                    if (state is InitialConnectedDeviceState ||
                        state is Disconnected) {
                      return Center(
                        child: Text('None device is connected'),
                      );
                    } else if (state is ConnectingToDevice) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Connecting to device...'),
                          SizedBox(
                            width: 10.0,
                          ),
                          CircularProgressIndicator(),
                        ],
                      );
                    } else if (state is ConnectedToDevice) {
                      String deviceAddress = state.device.address;
                      String deviceName = state.device.name;
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Connected to device: $deviceName',
                            ),
                            Text(
                              'Device address: $deviceAddress',
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Drive the vehicle with:'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                RaisedButton(
                                  child: Text('buttons'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DrivePage(),
                                      ),
                                    );
                                  },
                                ),
                                RaisedButton(
                                  child: Text('gyroscope'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DriveWithSensorsPage(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
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
              ),
            ],
          ),
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
