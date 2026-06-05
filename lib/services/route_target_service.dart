import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../database/database.dart';

class RouteTargetService {
  static const targetRouteKey = 'route_target.local_id';

  final AppDatabase db;
  final FlutterSecureStorage storage;

  const RouteTargetService({required this.db, required this.storage});

  Future<void> setTarget(SavedRoute route) {
    return storage.write(key: targetRouteKey, value: route.localId);
  }

  Future<void> clearTarget() {
    return storage.delete(key: targetRouteKey);
  }

  Future<SavedRoute?> loadTarget() async {
    final localId = await storage.read(key: targetRouteKey);
    if (localId == null || localId.trim().isEmpty) return null;
    final route = await db.getSavedRoute(localId);
    if (route == null) {
      await clearTarget();
    }
    return route;
  }
}
