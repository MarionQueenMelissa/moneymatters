import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_matters_v3/src/screens/homescreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _email, _password;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.amber,
        shadowColor: Colors.amber,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _password = value.trim();
                });
              },
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                  textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  auth
                      .signInWithEmailAndPassword(
                          email: _email, password: _password)
                      .then((_) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  });
                },
                child: Text('SignIn'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                  textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  auth
                      .createUserWithEmailAndPassword(
                          email: _email, password: _password)
                      .then((_) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  });
                },
                child: Text('SignUp'),
              ),
            ],
          ),
          SizedBox(
            height: 180,
          ),
          Text(
            'MoneyMatters',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.amber,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
