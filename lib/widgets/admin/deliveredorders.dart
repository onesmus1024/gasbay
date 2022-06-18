import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gasbay/views/map.dart';
import 'package:intl/intl.dart';
import 'package:gasbay/services/get_location_coordinates.dart';



class DeliveredOrders extends StatefulWidget {
  const DeliveredOrders({Key? key}) : super(key: key);

  @override
  State<DeliveredOrders> createState() => _DeliveredOrdersState();
}

class _DeliveredOrdersState extends State<DeliveredOrders> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .get()
          .then((value) => value.docs
              .where((element) => element.data()['isDelivered'] == true)
              .toList())
          .asStream(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.data !=null?(snapshot.data.length>0?ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            return  Card(
                        child: Column(
                          children:[  Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.network(
                                    snapshot.data[index]['imageUrl'],
                                    height: 150,
                                    width: MediaQuery.of(context).size.width * 0.4,
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('paid'),
                                          snapshot.data[index]['isPaid']
                                              ?IconButton( onPressed: () {
                                                   FirebaseFirestore.instance
                                                      .collection('orders')
                                                      .doc(snapshot.data[index]
                                                          .id)
                                                      .update({
                                                    'isPaid':  !snapshot.data[index]['isPaid']
                                                  });
                                                  setState(() {
                                                    
                                                  });
                                                
                                                
                                              },icon: const Icon(Icons.check),color: Colors.green)
                                              : IconButton( onPressed: () {
                                                   FirebaseFirestore.instance
                                                      .collection('orders')
                                                      .doc(snapshot.data[index]
                                                          .id)
                                                      .update({
                                                    'isPaid':  !snapshot.data[index]['isPaid']
                                                  });
                                                  setState(() {
                                                    
                                                  });
                                                
                                                
                                              },icon: const Icon(Icons.close),color: Colors.red)
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Delivered'),
                                          snapshot.data[index]['isDelivered']
                                              ? IconButton( onPressed: () {
                                                   FirebaseFirestore.instance
                                                      .collection('orders')
                                                      .doc(snapshot.data[index]
                                                          .id)
                                                      .update({
                                                    'isDelivered':  !snapshot.data[index]['isDelivered']
                                                  });
                                                  setState(() {
                                                    
                                                  });
                                                
                                                
                                              },icon: const Icon(Icons.check),color: Colors.green)
                                              : IconButton( onPressed: () {
                                                   FirebaseFirestore.instance
                                                      .collection('orders')
                                                      .doc(snapshot.data[index]
                                                          .id)
                                                      .update({
                                                    'isDelivered':  !snapshot.data[index]['isDelivered']
                                                  });
                                                  setState(() {
                                                    
                                                  });
                                                
                                                
                                              },icon: const Icon(Icons.close),color: Colors.red)
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('picked up'),
                                          snapshot.data[index]['isPicked']
                                              ? IconButton( onPressed: () {
                                                   FirebaseFirestore.instance
                                                      .collection('orders')
                                                      .doc(snapshot.data[index]
                                                          .id)
                                                      .update({
                                                    'isPicked':  !snapshot.data[index]['isPicked']
                                                  });
                                                  setState(() {
                                                    
                                                  });
                                                
                                                
                                              },icon: const Icon(Icons.check),color: Colors.green)
                                              : IconButton( onPressed: () {
                                                   FirebaseFirestore.instance
                                                      .collection('orders')
                                                      .doc(snapshot.data[index]
                                                          .id)
                                                      .update({
                                                    'isPicked':  !snapshot.data[index]['isPicked']
                                                  });
                                                  setState(() {
                                                    
                                                  });
                                                
                                                
                                              },icon: const Icon(Icons.close),color: Colors.red)
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
                              Row(
                              
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Destination'),
                                        Text(snapshot.data[index]['destination']),
                                        ElevatedButton(onPressed: ()async{
                                      List<double> latlong =await GetLocationCoordinates.getLatLong(snapshot.data[index]['destination']);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GetLocation(latlong: latlong)));
                                    }, child: const Text('view direction'),),
                                      ],
                                    ),
                              ],
                        ),
                      );
          },
        ):const Text('No delivered orders'))
            :const Center(child: CircularProgressIndicator(),);
      },
    );
  }
}
