import 'dart:async';

import 'package:app_for_arudino_vehicle/enums/position_enum.dart';
import 'package:app_for_arudino_vehicle/models/position.dart';
import 'package:app_for_arudino_vehicle/pages/drive_with_sensors/widgets/position_callibration_element.dart';
import 'package:app_for_arudino_vehicle/pages/drive_with_sensors/widgets/start_calibration_element.dart';
import 'package:flutter/material.dart';

import 'package:sensors/sensors.dart';

class DriveWithSensorsPage extends StatefulWidget {
  @override
  _DriveWithSensorsPageState createState() => _DriveWithSensorsPageState();
}

class _DriveWithSensorsPageState extends State<DriveWithSensorsPage> {
  StreamSubscription _streamSubscriptionAccelerometer;
  List<double> _accelerometerValues = <double>[];

  bool isSetupDone = false;

  List<Position> _calibratedPositions = <Position>[];
  StreamController<PositionEnum> _positions = StreamController<PositionEnum>();

  @override
  void initState() {
    super.initState();
    _streamSubscriptionAccelerometer =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscriptionAccelerometer.cancel();
  }

  void _nextPosition() {
    print('${PositionEnum.values.length}');
    print('${_calibratedPositions.length}');
    if (PositionEnum.values.length > _calibratedPositions.length) {
      _positions.add(PositionEnum.values[_calibratedPositions.length]);
    } else {
      _positions.close();
    }
  }

  void onCalibrateButtonClicked(PositionEnum positionEnum) {
    final List<double> accelerometer = _accelerometerValues
        ?.map((value) => double.parse(value.toStringAsFixed(1)))
        ?.toList();

    Position calibratedPosition = Position(
      classification: positionEnum,
      x: accelerometer[0],
      y: accelerometer[1],
      z: accelerometer[2],
    );

    _calibratedPositions.add(calibratedPosition);

    print(_calibratedPositions.toString());

    _nextPosition();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer =
        _accelerometerValues?.map((value) => value.toStringAsFixed(1))?.toList();

    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Visibility(
              visible: accelerometer != null,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'x: ${accelerometer[0]}',
                      style: TextStyle(
                        fontSize: 50.0,
                      ),
                    ),
                    Text(
                      'y: ${accelerometer[1]}',
                      style: TextStyle(
                        fontSize: 50.0,
                      ),
                    ),
                    Text(
                      'z: ${accelerometer[2]}',
                      style: TextStyle(
                        fontSize: 50.0,
                      ),
                    ),
                    StreamBuilder(
                      stream: _positions.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('error');
                        }

                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Container(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'None',
                                  ),
                                ],
                              ),
                            );
                            break;
                          case ConnectionState.waiting:
                            return StartCalibrationElement(
                              text: 'Start calibrating',
                              onButtonPressed: () {
                                _positions.add(PositionEnum.stop);
                              },
                            );
                            break;
                          case ConnectionState.active:
                            return PositionCalibrationElement(
                              positionEnum: snapshot.data,
                              onButtonPressed: () {
                                onCalibrateButtonClicked(snapshot.data);
                              },
                            );
                            break;
                          case ConnectionState.done:
                            return Container(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Done',
                                  ),
                                ],
                              ),
                            );
                            break;
                          default:
                            return null;
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
