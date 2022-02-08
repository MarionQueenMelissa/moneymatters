import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterwave/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';

class flutest extends StatefulWidget {
  @override
  State<flutest> createState() => _flutestState();
}

class _flutestState extends State<flutest> {
  TextEditingController _email = TextEditingController();
  TextEditingController _amount = TextEditingController();

  String? _ref;

  void setRef() {
    Random rand = Random();
    int number = rand.nextInt(3000);
    if (Platform.isAndroid) {
      setState(() {
        _ref = 'AndroidRef12389$number';
      });
    } else {
      setState(() {
        _ref = 'IOSRef12389$number';
      });
    }
  }

  @override
  void initState() {
    setRef();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Transactions'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: _amount,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                    ),
                  ),
                ),
              ],
            ),
          ),

          //button
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                final email = _email.text;
                final amount = _amount.text;
                if (email.isEmpty || amount.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Some fields are missing')));
                } else {
                  _makePayment(context, email.trim(), amount.trim());
                }
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                //height: 20.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.blue,
                child: Row(
                  children: [
                    Icon(
                      Icons.attach_money_outlined,
                      color: Colors.amber,
                    ),
                    Text(
                      'Make a payment',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _makePayment(BuildContext context, String email, String amount) async {
    try {
      Flutterwave flutterwave = Flutterwave.forUIPayment(
          context: this.context,
          encryptionKey: 'FLWSECK_TESTdd159b9708d3',
          publicKey: 'FLWPUBK_TEST-dd76292e8c6aa08ad4600b3bf52e3d59-X',
          currency: 'UGX',
          amount: amount,
          email: email,
          fullName: 'Omony Polycarp',
          txRef: _ref!,
          isDebugMode: true,
          phoneNumber: "0123456789",
          acceptCardPayment: true,
          acceptUSSDPayment: false,
          acceptAccountPayment: false,
          acceptFrancophoneMobileMoney: false,
          acceptGhanaPayment: false,
          acceptMpesaPayment: false,
          acceptRwandaMoneyPayment: false,
          acceptUgandaPayment: true,
          acceptZambiaPayment: false);

      final ChargeResponse response =
          await flutterwave.initializeForUiPayments();
      if (response == null) {
        print('Transaction failed');
      } else {
        if (response.status == 'success') {
          print(response.data);
          print(response.message);
        } else {
          print(response.message);
        }
      }
    } catch (error) {
      print(error);
    }
  }
}
