import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gasbay/views/home.dart';

import '../../views/admin_home.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool isLoggingIn = true;
  bool isSigningIn = false;
  String userName = '';
  String phoneNumber = '';
  String email = '';
  String password = '';
  // ignore: prefer_typing_uninitialized_variables
  var authenticateResult;

  final _formKey = GlobalKey<FormState>();

  void _setLogginIn() {
    setState(() {
      isLoggingIn = !isLoggingIn;
    });
  }

  bool _handleForm(BuildContext context) {
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  Future<void> login(BuildContext context) async {
    try {
      authenticateResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString().replaceRange(e.toString().indexOf('['),
                    e.toString().indexOf(']') + 1, '')),
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isSigningIn = false;
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text("try again"))
                ],
              ));
    }
  }

  Future<void> createNewUser(BuildContext context) async {
    try {
      authenticateResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(authenticateResult.user.uid)
          .set({
        'email': email,
        'userName': userName,
        'phoneNumber': phoneNumber,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'profileImage': '',
        'isAdmin': false,
        'isVerified': false,
        'isBlocked': false,
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString().replaceRange(e.toString().indexOf('['),
                    e.toString().indexOf(']') + 1, '')),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          isSigningIn = false;
                        });
                      },
                      child: const Text("try again"))
                ],
              ));
    }
  }

  Future<void> signUp(BuildContext context) async {
    if (isLoggingIn) {
      login(context);
    } else {
      createNewUser(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Card(
              elevation: 10,
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (!isLoggingIn)
                          TextFormField(
                            key: const ValueKey("username"),
                            decoration:
                                const InputDecoration(label: Text("username")),
                            onSaved: (value) {
                              userName = value!.trim();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enter a valid username";
                              }
                              return null;
                            },
                          ),
                        if (!isLoggingIn)
                          TextFormField(
                            key: const ValueKey("phoneNumber"),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                label: Text("phone number")),
                            onSaved: (value) {
                              phoneNumber = value!.trim();
                            },
                            validator: (value) {
                              if (value!.isEmpty || value.trim().length != 10) {
                                return "enter a valid phone";
                              }
                              return null;
                            },
                          ),
                        TextFormField(
                          key: const ValueKey("email"),
                          keyboardType: TextInputType.emailAddress,
                          decoration:
                              const InputDecoration(label: Text("email")),
                          onSaved: (value) {
                            email = value!.trim();
                          },
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return "enter a valid email";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          key: const ValueKey("password"),
                          obscureText: true,
                          decoration:
                              const InputDecoration(label: Text("password")),
                          onSaved: (value) {
                            password = value!.trim();
                          },
                          validator: (value) {
                            if (value!.isEmpty || value.length < 8) {
                              return "enter a valid password";
                            }
                            return null;
                          },
                        ),
                        if (!isLoggingIn)
                          TextFormField(
                            key: const ValueKey("confirmPassword"),
                            obscureText: true,
                            decoration: const InputDecoration(
                                label: Text("confirm password")),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "password did not match";
                              }
                              return null;
                            },
                          ),
                        isSigningIn
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () async {
                                  if(_handleForm(context)){
                                    setState(() {
                                      isSigningIn = true;
                                    });
                                    await signUp(context).then((value) => {
                                        if (authenticateResult != null)
                                          {
                                            FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(
                                                    authenticateResult.user.uid)
                                                .get()
                                                .then((value) {
                                              if (value.data()!['isAdmin'] ==
                                                  false) {
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                        Home.routeName);
                                              } else {
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                        AdminHome.routeName);
                                              }
                                            })
                                          }
                                        else
                                          {
                                            setState(() {
                                              isSigningIn = false;
                                            })
                                          }
                                      });
                                  }
                                  
                                  
                                },
                                child: isLoggingIn
                                    ? const Text("Login")
                                    : const Text("sign up")),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                            onPressed: _setLogginIn,
                            child: isLoggingIn
                                ? const Text("sign in instead?")
                                : const Text("Login instead?"))
                      ],
                    )),
              ))),
        ));
  }
}
