import 'dart:math';

import 'package:app_for_arudino_vehicle/enums/position_enum.dart';
import 'package:app_for_arudino_vehicle/models/position.dart';
import 'package:flutter/foundation.dart';

class AccelerometerCalculations {
  static PositionEnum getCalculatedPosition(
      List<Position> calibratedPositions, Position actualPosition) {
    List<DistanceToPosition> distanceToPositionList =
        calibratedPositions.map((position) {
      double distance = _calculateDistance(position, actualPosition);
      return DistanceToPosition(
        distance: distance,
        position: position.classification,
      );
    }).toList();

    // print(distanceToPositionList);

    DistanceToPosition theSmallestDistanceToPosition =
        distanceToPositionList.reduce((current, next) =>
            current.distance < next.distance ? current : next);

    print(theSmallestDistanceToPosition);

    return theSmallestDistanceToPosition.position;
  }

  static double _calculateDistance(Position first, Position second) {
    double xPart = pow(first.x - second.x, 2);
    double yPart = pow(first.y - second.y, 2);
    double zPart = pow(first.z - second.z, 2);

    double distance = sqrt(xPart + yPart + zPart);

    return distance;
  }
}

class DistanceToPosition {
  final double distance;
  final PositionEnum position;

  DistanceToPosition({@required this.distance, @required this.position});

  @override
  String toString() {
    return 'Distance $distance for position: $position';
  }
}
