import 'package:flutter/material.dart';

class CalibrationControllElement extends StatelessWidget {
  final Widget child;
  final Function onButtonPressed;
  final String buttonText;

  const CalibrationControllElement(
      {@required this.onButtonPressed, @required this.child, this.buttonText})
      : assert(onButtonPressed != null),
        assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          child,
          RaisedButton(
            child: Text(
              buttonText?? '',
            ),
            onPressed: () {
              onButtonPressed();
            },
          ),
        ],
      ),
    );
  }
}
