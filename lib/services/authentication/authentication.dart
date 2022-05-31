import 'package:flutter/material.dart';
import 'package:gasbay/services/authentication/authform.dart';

class SignIn extends StatefulWidget {
   const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AuthForm(),
      backgroundColor: Colors.blue,
    );
  }
}