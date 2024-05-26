

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class notificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.green, // Set the AppBar color to green
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('notifications').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No notifications found'));
          }

          var notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notificationData = notifications[index].data() as Map<String, dynamic>;
              var notificationMessage = notificationData['message'] ?? '';

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjusted margin
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white, // Set background color to white
                  border: Border.all(color: Colors.grey), // Add border
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  notificationMessage,
                  style: TextStyle(fontSize: 16.0),
                ),
              );
            },
          );
        },
      ),
    );
  }
}