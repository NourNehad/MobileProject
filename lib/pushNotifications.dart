// // notification_service.dart
// import 'dart:ui';

// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';

// void initializeNotifications() {
//   AwesomeNotifications().initialize(
//     'resource://drawable/res_app_icon',
//     [
//       NotificationChannel(
//         channelKey: 'basic_channel',
//         channelName: 'Basic notifications',
//         channelDescription: 'Notification channel for basic tests',
//         defaultColor: Color(0xFF9D50DD),
//         ledColor: Colors.white,
//         playSound: true,
//         enableVibration: true,
//         importance: NotificationImportance.High,
//       ),
//     ],
//   );
// }

// void requestNotificationPermission() {
//   AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
//     if (!isAllowed) {
//       AwesomeNotifications().requestPermissionToSendNotifications();
//     }
//   });
// }

// void sendPushNotification(String message) {
//   AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
//       channelKey: 'basic_channel',
//       title: 'New Comment',
//       body: message,
//     ),
//   );
// }
