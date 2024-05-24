import 'package:flutter/material.dart'; 
 
class loadingScreen extends StatelessWidget { 
   
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: Container(child: CircularProgressIndicator()), 
    ); 
  } 
} 