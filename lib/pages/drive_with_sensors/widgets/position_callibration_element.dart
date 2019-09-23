import 'package:app_for_arudino_vehicle/enums/position_enum.dart';
import 'package:app_for_arudino_vehicle/pages/drive_with_sensors/widgets/calibration_controll_element.dart';
import 'package:flutter/material.dart';

class PositionCalibrationElement extends StatelessWidget {
  final PositionEnum positionEnum;
  final Function onButtonPressed;

  const PositionCalibrationElement(
      {@required this.positionEnum, @required this.onButtonPressed})
      : assert(positionEnum != null),
        assert(onButtonPressed != null);

  String getTextToShow() {
    String direction;

    switch (positionEnum) {
      case PositionEnum.stop:
        direction = 'not driving in any direction';
        break;
      case PositionEnum.forward:
        direction = 'driving forward';
        break;
      case PositionEnum.forward_left:
        direction = 'driving left';
        break;
      case PositionEnum.forward_right:
        direction = 'driving right';
        break;
      case PositionEnum.backward:
        direction = 'driving backward';
        break;
      case PositionEnum.backward_left:
        direction = 'driving back to the left';
        break;
      case PositionEnum.backward_right:
        direction = 'driving back to the right';
        break;
      default:
        return 'Should be shown :( something strange happend';
    }

    String text = 'Calibrate: $direction\n';
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return CalibrationControllElement(
      onButtonPressed: onButtonPressed,
      child: Text(
        getTextToShow(),
      ),
      buttonText: positionEnum != PositionEnum.backward_right ? 'NEXT' : 'END',
    );
  }
}
