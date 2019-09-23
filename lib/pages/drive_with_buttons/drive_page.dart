import 'package:app_for_arudino_vehicle/bloc/bloc.dart';
import 'package:app_for_arudino_vehicle/pages/drive_with_buttons/widgets/arrows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ConnectedDeviceBloc, ConnectedDeviceState>(
          builder: (context, state) {
            if (state is ConnectedToDevice) {
              return Arrows(
                bluetoothConnection: state.bluetoothConnection,
              );
            } else {
              return Container(
                child: Center(
                  child: Text('Device is not connected'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
