import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:test/products/allProducts.dart';

class loginScreen extends StatefulWidget {
=======
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/products/allProducts.dart';

class LoginScreen extends StatefulWidget {
>>>>>>> 834fbfc507b8d0c8a1913f57f6bbf0eea39b37fa
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

<<<<<<< HEAD
class _LoginScreenState extends State<loginScreen> {
=======
class _LoginScreenState extends State<LoginScreen> {
>>>>>>> 834fbfc507b8d0c8a1913f57f6bbf0eea39b37fa
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var usernameController = TextEditingController();

  final authenticationInstance = FirebaseAuth.instance;

  var authenticationMode = 0;

  void toggleAuthMode() {
<<<<<<< HEAD
    if (authenticationMode == 0) {
      setState(() {
        authenticationMode = 1;
      });
    } else {
      setState(() {
        authenticationMode = 0;
      });
    }
  }

=======
    setState(() {
      authenticationMode = authenticationMode == 0 ? 1 : 0;
    });
  }

  Future<void> saveUserCredentials(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.uid);
    await prefs.setString('email', user.email ?? '');
  }

  Future<void> clearUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('email');
  }

>>>>>>> 834fbfc507b8d0c8a1913f57f6bbf0eea39b37fa
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text(
                "Welcome to Jewelleria",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              Text(
                authenticationMode == 1 ? "Create an account" : "Login",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                ),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Password",
                ),
                controller: passwordController,
                obscureText: true,
              ),
              if (authenticationMode == 1) ...[
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Username",
                    hintText: "Enter your username",
                  ),
                  controller: usernameController,
                ),
              ],
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
<<<<<<< HEAD
                  loginORsignup();
=======
                  loginOrSignup();
>>>>>>> 834fbfc507b8d0c8a1913f57f6bbf0eea39b37fa
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Center(
                  child: Text(authenticationMode == 1 ? "Sign up" : "Login"),
                ),
              ),
              const SizedBox(height: 16),
<<<<<<< HEAD
              const Center(
                child: Text(
                  "Or sign in with",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () {
                  toggleAuthMode();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                ),
                child: Text(authenticationMode == 1 ? "Login instead" : "Sign up instead"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => allProducts()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Center(
                  child: Text("Continue as Guest"),
                ),
              ),
=======
              TextButton(
                onPressed: () {
                  toggleAuthMode();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                ),
                child: Text(authenticationMode == 1 ? "Login instead" : "Sign up instead"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _signInAnonymously(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Center(
                  child: Text("Continue as Guest"),
                ),
              ),
>>>>>>> 834fbfc507b8d0c8a1913f57f6bbf0eea39b37fa
            ],
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD
  void loginORsignup() async {
=======
  void loginOrSignup() async {
>>>>>>> 834fbfc507b8d0c8a1913f57f6bbf0eea39b37fa
    var email = emailController.text.trim();
    var password = passwordController.text.trim();
    var username = usernameController.text.trim();
    var isVendor = false;

    UserCredential authResult;

    try {
      if (authenticationMode == 1) // sign up
      {
        authResult = await authenticationInstance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await FirebaseFirestore.instance.collection('users').doc(authResult.user!.uid).set({
          'username': username,
          'email': email,
          'isVendor': isVendor,
        });
<<<<<<< HEAD
=======

        if (authResult.user != null) {
          await saveUserCredentials(authResult.user!);
        }
>>>>>>> 834fbfc507b8d0c8a1913f57f6bbf0eea39b37fa
      } else // log in
      {
        authResult = await authenticationInstance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

<<<<<<< HEAD
=======
        if (authResult.user != null) {
          await saveUserCredentials(authResult.user!);
        }

>>>>>>> 834fbfc507b8d0c8a1913f57f6bbf0eea39b37fa
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => allProducts()),
        );
      }
    } catch (err) {
      print(err.toString());

      String errorMessage = "An error occurred";
      if (err.toString().contains("The supplied auth credential is incorrect, malformed or has expired")) {
        errorMessage = "Credentials are incorrect";
      } else if (err.toString().contains("The email address is badly formatted")) {
        errorMessage = "Wrong inputs validation. Make sure @ is included in your email!";
      } else if (err.toString().contains("Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.")) {
        errorMessage = "Access to this account has been temporarily disabled due to many failed login attempts. Please try again later";
      } else if (err.toString().contains("The email address is already in use by another account.")) {
        errorMessage = "The email address is already in use by another account.";
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 10),
                Text('Error', style: TextStyle(color: Colors.red)),
              ],
            ),
            content: Text(
              errorMessage,
              style: TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                  ),
                child: Text('OK', style: TextStyle(fontSize: 16)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
<<<<<<< HEAD
=======

  void _signInAnonymously(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signed in anonymously: ${userCredential.user!.uid}')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => allProducts()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in anonymously')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during anonymous sign-in: $e')),
      );
    }
  }
>>>>>>> 834fbfc507b8d0c8a1913f57f6bbf0eea39b37fa
}
