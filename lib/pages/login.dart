import 'package:auth/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/auth.dart';
import '../utils/colors.dart';
import '../widgets/reuseable_widgets.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? errMessage = ' ';
  bool isLogin = true;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  Future<void> signIn() async {
    try {
      await Auth().signIn(email: _email.text, password: _password.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errMessage = e.message;
      });
    }
  }

  Widget errorMessage() {
    return Text(errMessage == '' ? '' : '$errMessage');
  }

  Row signupOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have account?",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Register()));
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              "Sign Up",
              style: TextStyle(
                  color: Colors.lightBlue,
                  decoration: TextDecoration.underline),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            /* children: <Widget>[
                inputForm("Enter Email", Icons.person_outline, false, _email),
                const SizedBox(
                  height: 30,
                ),
                inputForm(
                    "Enter Password", Icons.lock_outline, true, _password),
                const SizedBox(
                  height: 30,
                ),
                submitBtn(context, true, signIn),
                signupOption()
              ]*/
          ),
        ),
      ),
    );
  }
}
