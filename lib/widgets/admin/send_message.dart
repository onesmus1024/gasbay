import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gasbay/views/new_message.dart';

class SendMessage extends StatelessWidget {
  const SendMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.data != null
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                        
                        child: GestureDetector(
                          onTap:()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>NewMessage(phoneNumber: snapshot.data.docs[index].data()['phoneNumber']))),  
                          child: Card(
                            elevation: 3,
                            child: Column(
                              children: [
                                
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Username",style: TextStyle(
                                            fontWeight: FontWeight.bold),),
                                      Text(snapshot.data.docs[index].data()['userName'],style: const TextStyle(
                                            fontWeight: FontWeight.bold),),
                                    ]),
                        
                                    Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("phoneNumber",style: TextStyle(
                                            fontWeight: FontWeight.bold),),
                                      Text(snapshot.data.docs[index].data()['phoneNumber'],style: const TextStyle(
                                            fontWeight: FontWeight.bold),),
                                    ]),
                                    
                                
                                
                              ],
                            ),
                          ),
                        ),
                      );
                },
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }
}
