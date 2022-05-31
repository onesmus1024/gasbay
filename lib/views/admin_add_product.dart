import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'admin_home.dart';

class AdminAddProduct extends StatefulWidget {
  const AdminAddProduct({Key? key}) : super(key: key);
  static const String routeName = '/adminAddProduct';

  @override
  State<AdminAddProduct> createState() => _AdminAddProductState();
}

class _AdminAddProductState extends State<AdminAddProduct> {
  String imageurl='';
  double price=00.00;
  String name='';
  String description ='';
  String gasType ='';
  XFile? _image;
  final ImagePicker picker = ImagePicker();
  Future<void> _getImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image!;
    });
    final ref =FirebaseStorage.instance.ref().child('prodiuct_images/').child(FirebaseAuth.instance.currentUser!.uid+'.jpg');
    if(_image != null ){
       ref.putFile(File(_image!.path));
        setState(() async {
      imageurl= await ref.getDownloadURL();
  
    });

    }

   
  }
  
  
  
  final _form = GlobalKey<FormState>();

  void _save() {
    
    
    if(_form.currentState!.validate())
    {
      _form.currentState!.save();
       FirebaseFirestore.instance.collection('products').add({
      'name': name,
      'description':description,
      'price':price,
      'gasType':gasType,
      'imageurl': imageurl,
      'isAvailable':true,

    }).then((value) => {
      Navigator.of(context).pushReplacementNamed(AdminHome.routeName)
    });

    }

   
  

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("products")),
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (newValue) =>
                        {
                          gasType = newValue.toString(),
                        },
                    validator: (newValue) {
                      if (newValue == null||newValue.isEmpty) {
                        return "This field can't be empty ";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text(
                        "Gas type/Cylinder type",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    maxLines: 4,
                    onSaved: (newValue) =>
                        {
                          name = newValue.toString(),
                        },
                    decoration: InputDecoration(
                      label: Text(
                        "name",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    maxLines: 4,
                    onSaved: (newValue) =>
                        {
                          description = newValue.toString(),
                        },
                    decoration: InputDecoration(
                        label: Text(
                          "description",
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        border: const OutlineInputBorder(),
                        hintMaxLines: 3),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    onSaved: (newValue) =>
                        {
                          price = double.parse(newValue.toString()),
                        }
                        ,
                    decoration: InputDecoration(
                        label: Text(
                          "price",
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        border: const OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                    _image != null?
                    Image.file(File(_image!.path),width: 200,height: 200):const Text("No image selected"),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      child: const Text("Select image"),
                      onPressed:() async {
                        await  _getImage();
                      },
                    ),
                    ],
                  )
                  ,
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width,child: ElevatedButton(onPressed: _save, child: const Text("submit")))
                ],
              ),
            )),
      ),
    );
  }
}