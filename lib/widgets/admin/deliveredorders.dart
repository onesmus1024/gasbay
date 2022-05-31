import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gasbay/views/map.dart';
import 'package:intl/intl.dart';
import 'package:gasbay/services/get_location_coordinates.dart';



class DeliveredOrders extends StatelessWidget {
  const DeliveredOrders({Key? key}) : super(key: key);

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
                          children:[ Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.network(
                                  'https://media.istockphoto.com/photos/different-types-of-gas-bottles-isolated-on-white-background-picture-id1288462295?b=1&k=20&m=1288462295&s=170667a&w=0&h=N1OAtzdtQDaUjvUozRFUximkNmpYeIX8BQl-V5citVk=',
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
                                        const Text('picked up'),
                                        snapshot.data[index]['isPicked']
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
