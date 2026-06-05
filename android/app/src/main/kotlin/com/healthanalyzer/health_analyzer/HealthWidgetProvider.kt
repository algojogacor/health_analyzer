package com.healthanalyzer.health_analyzer

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.RemoteViews

class HealthWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (widgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, widgetId)
        }
    }

    companion object {
        private const val PREFS = "health_widget"
        private const val KEY_STEPS = "steps"
        private const val KEY_READINESS_SCORE = "readiness_score"
        private const val KEY_READINESS_LABEL = "readiness_label"
        private const val KEY_UPDATED_AT = "updated_at"

        fun updateAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, HealthWidgetProvider::class.java),
            )
            for (id in ids) {
                updateWidget(context, manager, id)
            }
        }

        fun updateWidget(
            context: Context,
            manager: AppWidgetManager,
            widgetId: Int,
        ) {
            val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            val steps = prefs.getInt(KEY_STEPS, -1)
            val readiness = prefs.getInt(KEY_READINESS_SCORE, -1)
            val readinessLabel = prefs.getString(KEY_READINESS_LABEL, "Open app")
                ?: "Open app"
            val updatedAt = prefs.getString(KEY_UPDATED_AT, "Not updated yet")
                ?: "Not updated yet"

            val views = RemoteViews(context.packageName, R.layout.health_widget)
            views.setTextViewText(
                R.id.widget_steps,
                if (steps >= 0) "%,d".format(steps) else "--",
            )
            views.setTextViewText(
                R.id.widget_readiness,
                if (readiness >= 0) "$readiness" else "--",
            )
            views.setTextViewText(R.id.widget_readiness_label, readinessLabel)
            views.setTextViewText(R.id.widget_updated, updatedAt)
            views.setOnClickPendingIntent(
                R.id.widget_root,
                openAppIntent(context, "dashboard"),
            )
            views.setOnClickPendingIntent(
                R.id.widget_quick_start,
                openAppIntent(context, "activity"),
            )
            manager.updateAppWidget(widgetId, views)
        }

        private fun openAppIntent(context: Context, target: String): PendingIntent {
            val intent = Intent(context, MainActivity::class.java).apply {
                putExtra("health_widget_target", target)
                flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val flags = PendingIntent.FLAG_UPDATE_CURRENT or
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    PendingIntent.FLAG_IMMUTABLE
                } else {
                    0
                }
            return PendingIntent.getActivity(
                context,
                target.hashCode(),
                intent,
                flags,
            )
        }
    }
}
