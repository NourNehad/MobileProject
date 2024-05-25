import "package:flutter/material.dart";


class errorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Error initializing Firebase",
          style: TextStyle(fontSize: 24, color: Colors.red),
        ),
      ),
    );
  }
}