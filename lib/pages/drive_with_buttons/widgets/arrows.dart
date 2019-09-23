import 'dart:convert';

import 'package:app_for_arudino_vehicle/pages/drive_with_buttons/enums/arrow_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'arrow_button.dart';

class Arrows extends StatefulWidget {
  final BluetoothConnection bluetoothConnection;

  const Arrows({@required this.bluetoothConnection})
      : assert(bluetoothConnection != null);

  @override
  _ArrowsState createState() => _ArrowsState();
}

class _ArrowsState extends State<Arrows> {
  Set<ArrowType> pressedButtons = Set<ArrowType>();

  onTapDown(ArrowType type) {
    print('down from arrow: $type');
    pressedButtons.add(type);
    _sendMessege();
  }

  onTapUp(ArrowType type) {
    print('up from arrow: $type');
    pressedButtons.remove(type);
    _sendMessege();
  }

  _sendMessege() {
    int vehicleDirrection;
    switch (pressedButtons.length) {
      case 0:
        vehicleDirrection = 9;
        break;
      case 1:
        vehicleDirrection = _sendMessageWhenOneButtonIsBeingPressed();
        break;
      case 2:
        vehicleDirrection = _sendMessageWhenTwoButtonIsBeingPressed();
        break;
      case 3:
        vehicleDirrection = 0;
        break;
      case 4:
        vehicleDirrection = 0;
        break;
      default:
        print('error');
        vehicleDirrection = 0;
    }

    widget.bluetoothConnection.output
        .add(ascii.encode(vehicleDirrection.toString()));
    print('send ${vehicleDirrection.toString()}');
  }

  int _sendMessageWhenOneButtonIsBeingPressed() {
    ArrowType arrowType = pressedButtons.first;
    switch (arrowType) {
      case ArrowType.up:
        return 1;
        break;
      case ArrowType.down:
        return 2;
        break;
      case ArrowType.left:
        return 0;
        break;
      case ArrowType.right:
        return 0;
        break;
      default:
        return 0;
    }
  }

  int _sendMessageWhenTwoButtonIsBeingPressed() {
    // breake
    if (pressedButtons.containsAll([ArrowType.up, ArrowType.down])) {
      return 9;
    }

    if (pressedButtons.containsAll([ArrowType.up, ArrowType.left])) {
      return 3;
    }
    if (pressedButtons.containsAll([ArrowType.up, ArrowType.right])) {
      return 4;
    }

    if (pressedButtons.containsAll([ArrowType.down, ArrowType.left])) {
      return 5;
    }
    if (pressedButtons.containsAll([ArrowType.down, ArrowType.right])) {
      return 6;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 350.0,),
          Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  ArrowButton(
                    arrowType: ArrowType.left,
                    icon: Icons.arrow_back,
                    onTapDown: onTapDown,
                    onTapUp: onTapUp,
                  ),
                  ArrowButton(
                    arrowType: ArrowType.right,
                    icon: Icons.arrow_forward,
                    onTapDown: onTapDown,
                    onTapUp: onTapUp,
                  ),
                ],
              ),
              SizedBox(
                width: 50.0,
              ),
              Column(
                children: <Widget>[
                  ArrowButton(
                    arrowType: ArrowType.up,
                    icon: Icons.arrow_upward,
                    onTapDown: onTapDown,
                    onTapUp: onTapUp,
                  ),
                  ArrowButton(
                    arrowType: ArrowType.down,
                    icon: Icons.arrow_downward,
                    onTapDown: onTapDown,
                    onTapUp: onTapUp,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
