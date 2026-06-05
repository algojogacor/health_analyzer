package com.healthanalyzer.health_analyzer

import android.os.Build
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "health_analyzer/widget",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "updateHomeWidget" -> {
                    val prefs = getSharedPreferences("health_widget", MODE_PRIVATE)
                    prefs.edit()
                        .putInt("steps", call.argument<Int>("steps") ?: -1)
                        .putInt(
                            "readiness_score",
                            call.argument<Int>("readinessScore") ?: -1,
                        )
                        .putString(
                            "readiness_label",
                            call.argument<String>("readinessLabel") ?: "Open app",
                        )
                        .putString(
                            "updated_at",
                            call.argument<String>("updatedAt") ?: "Updated now",
                        )
                        .apply()
                    HealthWidgetProvider.updateAll(this)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "health_analyzer/recording_service",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> {
                    val sportName = call.argument<String>("sportName") ?: "Activity"
                    val sessionLocalId = call.argument<String>("sessionLocalId") ?: ""
                    val requiresGps = call.argument<Boolean>("requiresGps") ?: false
                    val intent = RecordingForegroundService.startIntent(
                        this,
                        sportName,
                        sessionLocalId,
                        requiresGps,
                    )
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success(null)
                }
                "update" -> {
                    val intent = RecordingForegroundService.updateIntent(
                        this,
                        call.argument<String>("sportName") ?: "Activity",
                        call.argument<String>("status") ?: "Recording",
                        call.argument<Int>("elapsedSeconds") ?: 0,
                        call.argument<Int>("movingSeconds") ?: 0,
                        call.argument<Double>("distanceMeters") ?: 0.0,
                    )
                    startService(intent)
                    result.success(null)
                }
                "stop" -> {
                    startService(RecordingForegroundService.stopIntent(this))
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
