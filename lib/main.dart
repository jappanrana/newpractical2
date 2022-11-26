import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:newpractical2/add_user.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practical2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddUser(),
    );
  }
}