import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app_flutter/screens/myHomePage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        canvasColor: Colors.pink[50],
        backgroundColor: Colors.pinkAccent[100],
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pinkAccent[200],
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        textTheme: const TextTheme(
            headline1: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
        )),
      ),

      home: const MyHomePage(),
    );
  }
}
