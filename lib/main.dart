import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money_matters_v3/src/app.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_matters_v3/src/screens/homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('money');

  runApp(App());
}
