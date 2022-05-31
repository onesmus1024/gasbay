import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gasbay/services/authentication/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gasbay/views/admin_add_product.dart';
import 'package:gasbay/views/admin_home.dart';
import 'package:gasbay/views/home.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'package:gasbay/keys/globay_key.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MpesaFlutterPlugin.setConsumerKey(consumerKey);
  MpesaFlutterPlugin.setConsumerSecret(consumerSecret);
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      title: 'gasbay',
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .get()
                  .then((value) {
                if (value.data()!['isAdmin'] == false) {
                  Navigator.of(context).pushReplacementNamed(Home.routeName);
                } else {
                   Navigator.of(context)
                      .pushReplacementNamed(AdminHome.routeName);
                }
              });
              
              return Container();
            } else {
              return const SignIn();
            }
          }),
      routes: {
        AdminHome.routeName: (context) => const AdminHome(),
        Home.routeName: (context) => const Home(),
        AdminAddProduct.routeName: (context) => const AdminAddProduct(),
      },
    );
  }
}
