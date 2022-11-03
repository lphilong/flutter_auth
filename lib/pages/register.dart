import 'package:auth/pages/login.dart';
import 'package:auth/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/auth.dart';
import '../widgets/reuseable_widgets.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? errMessage = ' ';
  bool isLogin = true;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _validateUserName(String? text) {
    if (text == null || text.isEmpty) {
      return 'Username is required';
    }
    if (text.length < 4) {
      return 'Too short';
    }
    return null;
  }

  String? _validateEmail(String? text) {
    if (text == null || text.isEmpty) {
      return 'Email is required';
    }
    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(text)) {
      return 'Invalid Email';
    }
    return null;
  }

  String? _validatePassword(String? text) {
    if (text == null || text.isEmpty) {
      return 'Password is required';
    }
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z)(?=.*?[0-9)(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(text)) {
      return 'Password must be atleast 8 characters\nInclude an uppercase letter, number and symbol';
    }

    return null;
  }

  Future<void> createUser() async {
    try {
      if (_formKey.currentState!.validate()) {
        await Auth()
            .createUser(email: _email.text, password: _password.text)
            .then((val) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Login()));
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errMessage = e.message;
      });
    }
  }

  Widget errorMessage() {
    return Text(errMessage == '' ? '' : 'Humm ? $errMessage');
  }

  Row loginOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have account?",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const Login()));
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              "Login",
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            inputForm("Enter Username", Icons.person_outline,
                                false, _userName, _validateUserName),
                            const SizedBox(
                              height: 30,
                            ),
                            inputForm("Enter Email", Icons.mail_outline, false,
                                _email, _validateEmail),
                            const SizedBox(
                              height: 30,
                            ),
                            inputForm("Enter Password", Icons.lock_outline,
                                true, _password, _validatePassword),
                            const SizedBox(
                              height: 15,
                            ),
                            inputForm("Re-enter Password", Icons.lock_outline,
                                true, _confirmPassword, (text) {
                              if (text == null || text.isEmpty) {
                                return 'Password is required';
                              }
                              if (text != _password.text) {
                                return 'password does not match!';
                              }
                              return null;
                            }),
                            const SizedBox(
                              height: 30,
                            ),
                            submitBtn(context, false, createUser),
                            loginOption()
                          ]),
                    ),
                  ),
                ),
              ),
            )));
  }
}
