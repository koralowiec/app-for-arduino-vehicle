import 'package:app_for_arudino_vehicle/enums/position_enum.dart';
import 'package:flutter/foundation.dart';

class Position {
  final double x;
  final double y;
  final double z;

  final PositionEnum classification;

  Position({
    @required this.classification,
    @required this.x,
    @required this.y,
    @required this.z,
  });

  @override
  String toString() {
    return '\nPosition: $classification, x: $x, y: $y, z: $z';
  }
}
