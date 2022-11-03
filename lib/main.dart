import 'package:auth/auth/auth.dart';
import 'package:auth/pages/home.dart';
import 'package:auth/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
          stream: Auth().authStateChanges,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return HomePage();
            } else {
              return const Register();
            }
          })),
    );
  }
}
