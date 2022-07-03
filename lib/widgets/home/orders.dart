import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Orders extends StatelessWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .get()
          .then((value) => value.docs
              .where((element) =>
                  element.data()['customerId'] ==
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
                      return Card(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.network(
                                snapshot.data[index]['imageUrl'],
                                height: 200,
                                width: MediaQuery.of(context).size.width/2.5,
                                
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Destination  '),
                                      Text(snapshot.data[index]['destination'])
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('paid'),
                                      snapshot.data[index]['isPaid']
                                          ? const Icon(Icons.check,
                                              color: Colors.green)
                                          : const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Delivered'),
                                      snapshot.data[index]['isDelivered']
                                          ? const Icon(Icons.check,
                                              color: Colors.green)
                                          : const Icon(Icons.close,
                                              color: Colors.red)
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Order Date '),
                                      Text(
                                        DateFormat.yMMMEd()

                                            // displaying formatted date
                                            .format(DateTime.now()),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ]),
                      );
                    },
                  )
                : const Text('No orders'))
            : const Center(child: CircularProgressIndicator(),);
      },
    );
  }
}
