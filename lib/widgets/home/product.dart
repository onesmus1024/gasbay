import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gasbay/views/product_detail.dart';

class Products extends StatelessWidget {
  const Products({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: snapshot.data != null
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetail(
                                id: Timestamp.now().toString(),
                                image:snapshot.data.docs[index].data()['imageUrl'],
                                description: snapshot.data.docs[index]
                                    .data()['description'],
                                price:
                                    snapshot.data.docs[index].data()['price'],
                              ),
                            ));
                      },
                      child: Container(
                          margin: const EdgeInsets.all(20),
                          width: 300,
                          height: MediaQuery.of(context).size.height / 3,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                           
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width*0.5,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Image.network(
                                  snapshot.data.docs[index].data()['imageUrl'],
                                  height: 150,
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.purple));
                                    }
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                          child: CircularProgressIndicator(
                                    color: Colors.purple,
                                  )),
                                ),
                              ),
                              Positioned(
                                  top: 30,
                                  right: 5,
                                  child: Text(
                                    '${snapshot.data.docs[index].data()['price']} ksh',
                                    style: const TextStyle(
                                        color: Colors.purple,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  )),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  child: const Text("-50%"),
                                  decoration:  const BoxDecoration(
                                    borderRadius:BorderRadius.all(Radius.circular(20)),
                                    color: Color.fromARGB(255, 230, 173, 16),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom:0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  width: 250,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                          snapshot.data.docs[index]
                                              .data()['name'],
                                          style: const TextStyle(
                                              color: Colors.purple,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w900)),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                              snapshot.data.docs[index]
                                                  .data()['gasType'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6)),
                                      
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Row(
                                children:const [
                                  Text('verified status'),
                                  Icon(Icons.verified_user,color: Colors.green,),
                                
                                ]
                              ))
                            ],
                          )),
                    );
                  },
                )
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
