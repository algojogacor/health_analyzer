import 'package:flutter_test/flutter_test.dart';
import 'package:health_analyzer/services/route_crop_service.dart';

void main() {
  test('empty route returns zero crop state', () {
    final state = RouteCropCalculator.calculate(const [], hiddenMeters: 300);

    expect(state.hiddenMeters, 0);
    expect(state.totalDistanceMeters, 0);
    expect(state.visiblePoints, isEmpty);
  });

  test('short route uses 20 percent minimum visible distance', () {
    final points = [
      const CropRoutePoint(latitude: 0, longitude: 0),
      const CropRoutePoint(latitude: 0, longitude: 0.0045),
    ];
    final state = RouteCropCalculator.calculate(points, hiddenMeters: 10000);

    expect(state.totalDistanceMeters, greaterThan(450));
    expect(state.totalDistanceMeters, lessThan(550));
    expect(state.minVisibleMeters, closeTo(state.totalDistanceMeters * 0.2, 1));
    expect(
      state.hiddenMeters * 2,
      lessThanOrEqualTo(state.totalDistanceMeters),
    );
  });

  test('long route clamps to keep at least 200m visible', () {
    final points = [
      const CropRoutePoint(latitude: 0, longitude: 0),
      const CropRoutePoint(latitude: 0, longitude: 0.05),
    ];
    final state = RouteCropCalculator.calculate(points, hiddenMeters: 10000);

    expect(state.minVisibleMeters, closeTo(200, 0.1));
    expect(
      state.totalDistanceMeters - (state.hiddenMeters * 2),
      greaterThanOrEqualTo(199.9),
    );
  });
}
