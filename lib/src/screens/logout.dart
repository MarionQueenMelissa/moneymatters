import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_matters_v3/src/screens/login.dart';

class LogoutScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset('assets/images/MoneyMattersLogo.png'),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Row(
                children: [
                  SizedBox(
                    width: 70,
                  ),
                  Icon(
                    Icons.logout,
                    size: 32.0,
                    color: Colors.amber,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.black12,
                    ),
                    padding: EdgeInsets.all(12.0),
                    child: TextButton(
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.amber,
                          // fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {
                        auth.signOut();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
