import 'package:flutter/material.dart';

class DeviceItem extends StatelessWidget {
  final String deviceName;

  const DeviceItem({@required this.deviceName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            Text(
              deviceName,
            )
          ],
        ),
      ),
    );
  }
}
