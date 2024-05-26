package com.example.app

import android.app.Application
import io.flutter.app.FlutterApplication
import me.carda.awesome_notifications.AwesomeNotifications

class MainActivity : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        AwesomeNotifications().initialize(
            this,
            'resource://drawable/res_app_icon',
            listOf(
                NotificationChannel(
                    channelKey: 'basic_channel',
                    channelName: 'Basic notifications',
                    channelDescription: 'Notification channel for basic tests',
                    defaultColor: Color(0xFF9D50DD),
                    ledColor: Color.WHITE,
                    playSound: true,
                    enableVibration: true,
                    importance: NotificationImportance.High,
                )
            )
        )
    }
}
