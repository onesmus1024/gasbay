import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gasbay/views/admin_add_product.dart';
import 'package:gasbay/widgets/admin/completeorders.dart';
import 'package:gasbay/widgets/admin/deliveredorders.dart';
import 'package:gasbay/widgets/admin/pendingorders.dart';
import 'package:gasbay/widgets/admin/send_message.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);
  static const String routeName = '/adminhome';

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;
  static const List<Widget> _options = <Widget>[
    PendingOrders(),
    DeliveredOrders(),
    CompleteOrders(),
    SendMessage()
  ];
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('GASBAY Admin'),
          backgroundColor: Colors.teal,
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                 Navigator.pushNamed(context, '/');},
                icon: const Icon(Icons.logout))
          ]),
      body: Center(
        child: _options.elementAt(_selectedIndex),
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.purple,
        ),
        child: IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, AdminAddProduct.routeName),
            icon: const Icon(Icons.add)),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'pending orders',
                backgroundColor: Colors.teal),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_basket),
                label: 'delivered orders',
                backgroundColor: Colors.cyan),
            BottomNavigationBarItem(
              icon: Icon(Icons.shop),
              label: 'complete orders',
              backgroundColor: Colors.lightBlue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.send),
              label: 'send messages ',
              backgroundColor: Color.fromARGB(255, 69, 77, 202),
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          iconSize: 40,
          onTap: _onItemTap,
          elevation: 5),
    );
  }
}
