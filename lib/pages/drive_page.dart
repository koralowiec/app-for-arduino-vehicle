import 'package:flutter/material.dart';

class DrivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text('<'),
                ),
                Column(
                  children: <Widget>[
                    RaisedButton(
                      child: Text('^'),
                    ),
                    RaisedButton(
                      child: Text('v'),
                    )
                  ],
                ),
                RaisedButton(
                  child: Text('>'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
