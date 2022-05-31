import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((value) => value.docs
              .where((element) =>
                  element.data()['userId'] ==
                  FirebaseAuth.instance.currentUser!.uid)
              .toList())
          .asStream(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.data != null
            ? (snapshot.data.length > 0
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Card(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 100,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Username",style: TextStyle(
                                          fontWeight: FontWeight.bold),),
                                    Text(snapshot.data[index]['userName'])
                                  ]),
                                  const SizedBox(
                                    height: 20,
                                  ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Email",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(snapshot.data[index]['email'])
                                  ]),
                                   const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Phone",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(snapshot.data[index]['phoneNumber']
                                  .toString()),
                                  ]),
                                   const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Verified",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                   snapshot.data[index]['isVerified']?const Icon(Icons.verified,color: Colors.green,):Row(mainAxisAlignment: MainAxisAlignment.end,children: const[ Text('not verified'),Icon(Icons.close,color: Colors.red,)],)
                                  ]),
                              
                              
                              
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Text('you are no a verified user'))
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
