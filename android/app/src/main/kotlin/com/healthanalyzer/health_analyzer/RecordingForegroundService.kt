package com.healthanalyzer.health_analyzer

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import android.os.PowerManager

class RecordingForegroundService : Service() {
    private var wakeLock: PowerManager.WakeLock? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_STOP -> stopService()
            ACTION_UPDATE -> updateNotification(intent)
            else -> startRecording(intent)
        }
        return START_STICKY
    }

    override fun onDestroy() {
        releaseWakeLock()
        super.onDestroy()
    }

    private fun startRecording(intent: Intent?) {
        ensureChannel()
        acquireWakeLock()
        val notification = buildNotification(
            sportName = intent?.getStringExtra(EXTRA_SPORT_NAME) ?: "Activity",
            status = "Recording",
            elapsedSeconds = 0,
            movingSeconds = 0,
            distanceMeters = 0.0,
        )
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(
                NOTIFICATION_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION,
            )
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
    }

    private fun updateNotification(intent: Intent) {
        val notification = buildNotification(
            sportName = intent.getStringExtra(EXTRA_SPORT_NAME) ?: "Activity",
            status = intent.getStringExtra(EXTRA_STATUS) ?: "Recording",
            elapsedSeconds = intent.getIntExtra(EXTRA_ELAPSED_SECONDS, 0),
            movingSeconds = intent.getIntExtra(EXTRA_MOVING_SECONDS, 0),
            distanceMeters = intent.getDoubleExtra(EXTRA_DISTANCE_METERS, 0.0),
        )
        val manager = getSystemService(NotificationManager::class.java)
        manager.notify(NOTIFICATION_ID, notification)
    }

    private fun stopService() {
        releaseWakeLock()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            stopForeground(STOP_FOREGROUND_REMOVE)
        } else {
            @Suppress("DEPRECATION")
            stopForeground(true)
        }
        stopSelf()
    }

    private fun ensureChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = getSystemService(NotificationManager::class.java)
        val existing = manager.getNotificationChannel(CHANNEL_ID)
        if (existing != null) return
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Activity recording",
            NotificationManager.IMPORTANCE_LOW,
        ).apply {
            description = "Keeps GPS activity recording alive."
            setShowBadge(false)
        }
        manager.createNotificationChannel(channel)
    }

    private fun buildNotification(
        sportName: String,
        status: String,
        elapsedSeconds: Int,
        movingSeconds: Int,
        distanceMeters: Double,
    ): Notification {
        val openIntent = packageManager.getLaunchIntentForPackage(packageName)
            ?: Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            openIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or immutableFlag(),
        )
        val distanceKm = distanceMeters / 1000.0
        val content = "${formatDuration(movingSeconds)} moving • ${"%.2f".format(distanceKm)} km"
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }
        return builder
            .setSmallIcon(android.R.drawable.ic_menu_mylocation)
            .setContentTitle("$status $sportName")
            .setContentText(content)
            .setSubText(formatDuration(elapsedSeconds))
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setCategory(Notification.CATEGORY_SERVICE)
            .build()
    }

    private fun acquireWakeLock() {
        if (wakeLock?.isHeld == true) return
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "HealthAnalyzer:ActivityRecording",
        ).apply {
            setReferenceCounted(false)
            acquire()
        }
    }

    private fun releaseWakeLock() {
        val lock = wakeLock
        if (lock?.isHeld == true) lock.release()
        wakeLock = null
    }

    private fun formatDuration(seconds: Int): String {
        val safeSeconds = seconds.coerceAtLeast(0)
        val hours = safeSeconds / 3600
        val minutes = (safeSeconds % 3600) / 60
        val secs = safeSeconds % 60
        return if (hours > 0) {
            "%d:%02d:%02d".format(hours, minutes, secs)
        } else {
            "%d:%02d".format(minutes, secs)
        }
    }

    private fun immutableFlag(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_IMMUTABLE
        } else {
            0
        }
    }

    companion object {
        private const val CHANNEL_ID = "activity_recording"
        private const val NOTIFICATION_ID = 2042
        private const val ACTION_START = "com.healthanalyzer.health_analyzer.recording.START"
        private const val ACTION_UPDATE = "com.healthanalyzer.health_analyzer.recording.UPDATE"
        private const val ACTION_STOP = "com.healthanalyzer.health_analyzer.recording.STOP"
        private const val EXTRA_SPORT_NAME = "sportName"
        private const val EXTRA_STATUS = "status"
        private const val EXTRA_ELAPSED_SECONDS = "elapsedSeconds"
        private const val EXTRA_MOVING_SECONDS = "movingSeconds"
        private const val EXTRA_DISTANCE_METERS = "distanceMeters"

        fun startIntent(
            context: Context,
            sportName: String,
            sessionLocalId: String,
            requiresGps: Boolean,
        ): Intent {
            return Intent(context, RecordingForegroundService::class.java).apply {
                action = ACTION_START
                putExtra(EXTRA_SPORT_NAME, sportName)
                putExtra("sessionLocalId", sessionLocalId)
                putExtra("requiresGps", requiresGps)
            }
        }

        fun updateIntent(
            context: Context,
            sportName: String,
            status: String,
            elapsedSeconds: Int,
            movingSeconds: Int,
            distanceMeters: Double,
        ): Intent {
            return Intent(context, RecordingForegroundService::class.java).apply {
                action = ACTION_UPDATE
                putExtra(EXTRA_SPORT_NAME, sportName)
                putExtra(EXTRA_STATUS, status)
                putExtra(EXTRA_ELAPSED_SECONDS, elapsedSeconds)
                putExtra(EXTRA_MOVING_SECONDS, movingSeconds)
                putExtra(EXTRA_DISTANCE_METERS, distanceMeters)
            }
        }

        fun stopIntent(context: Context): Intent {
            return Intent(context, RecordingForegroundService::class.java).apply {
                action = ACTION_STOP
            }
        }
    }
}
