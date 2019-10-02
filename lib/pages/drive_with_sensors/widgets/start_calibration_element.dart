import 'package:app_for_arudino_vehicle/pages/drive_with_sensors/widgets/calibration_controll_element.dart';
import 'package:flutter/material.dart';

class StartCalibrationElement extends StatelessWidget {
  final String text;
  final Function onButtonPressed;

  const StartCalibrationElement(
      {@required this.text, @required this.onButtonPressed})
      : assert(text != null),
        assert(onButtonPressed != null);

  @override
  Widget build(BuildContext context) {
    return CalibrationControllElement(
      child: Text(text),
      onButtonPressed: onButtonPressed,
      buttonText: 'START',
    );
  }
}
