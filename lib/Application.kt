package com.example.app

import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import me.carda.awesome_notifications.AwesomeNotifications

class Application : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        AwesomeNotifications().initialize(
            "resource://drawable/res_app_icon",
            listOf(
                NotificationChannel(
                    channelKey = "basic_channel",
                    channelName = "Basic notifications",
                    channelDescription = "Notification channel for basic tests",
                    defaultColor = Color(0xFF9D50DD),
                    ledColor = Color.WHITE,
                    playSound = true,
                    enableVibration = true,
                    importance = NotificationImportance.High
                )
            )
        )
    }
}
