import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gasbay/services/twilio_messages.dart';

// ignore: must_be_immutable
class NewMessage extends StatefulWidget {
 NewMessage({Key? key,required this.phoneNumber}) : super(key: key);
  String phoneNumber;

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _message = '';
  void _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('messages')
          .add({
        "text": _message,
        'createdAt': Timestamp.now(),
        'userId': user.uid
      });
      FirebaseFirestore.instance
          .collection('messages')
          .add({
        "text": _message,
        'createdAt': Timestamp.now(),
        'userId': user.uid
      });
      TwilioSendMessage(phoneNumber: widget.phoneNumber, message: _message).sendSms().then((value) => 
      {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Icon(Icons.check_circle_outline_outlined,color: Colors.green,size: 100,),
                title: const Text("Message Sent"),
                actions: [
                  TextButton(
                      onPressed: () {

                        Navigator.of(context).pop();
                      },
                      child: const Text("ok"))
                ],
              ))

      }
      );
      setState(() {
        _controller.clear();
        _message = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.phoneNumber),
        backgroundColor: Colors.teal,
      ),
      body:  Column(
        children:[ const Expanded(child: Text(''),),Row(
          children: [
            
            
            Expanded(
              child: TextFormField(
                
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    _message = value;
                  });
                },
                decoration:
                    const InputDecoration(label: Text("Type new message ...")),
              ),
            ),
            IconButton(
                onPressed: _message.trim().isEmpty ? null : _sendMessage,
                icon: const Icon(Icons.send))
          ],
        ),]
      ),
    );
  }
}