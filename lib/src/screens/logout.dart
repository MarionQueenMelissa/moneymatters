import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_matters_v3/src/screens/login.dart';

class LogoutScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text('Logout'),
          onPressed: () {
            auth.signOut();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        ),
      ),
    );
  }
}
