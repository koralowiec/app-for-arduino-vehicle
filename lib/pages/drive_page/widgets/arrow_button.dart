import 'package:app_for_arudino_vehicle/pages/drive_page/enums/arrow_types.dart';
import 'package:flutter/material.dart';

class ArrowButton extends StatelessWidget {
  final IconData icon;
  final Function onTapDown;
  final Function onTapUp;
  final ArrowType arrowType;

  const ArrowButton({
    this.icon,
    @required this.onTapDown,
    @required this.onTapUp,
    @required this.arrowType,
  }) : assert(onTapDown != null, onTapUp != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (tapDownDeatails) {
        print('down');
        onTapDown(arrowType);
      },
      onTapUp: (tapDownDeatails) {
        print('up');
        onTapUp(arrowType);
      },
      child: Container(
        height: 100.0,
        width: 100.0,
        decoration: BoxDecoration(color: Colors.grey[300]),
        child: Icon(
          icon,
        ),
      ),
    );
  }
}
