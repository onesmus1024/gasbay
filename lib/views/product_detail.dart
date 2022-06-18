
import 'package:flutter/material.dart';
import './checkout.dart';

// ignore: must_be_immutable
class ProductDetail extends StatefulWidget {
  const ProductDetail(
      {Key? key,
      required this.id,
      required this.image,
      required this.description,
      required this.price})
      : super(key: key);
  final String id;
  final String image;
  final String description;
  final double price;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool liked = false;
  bool showlike = false;
  void _handlelike() {
    setState(() {
      liked = !liked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        title: const  Text('product details'),
        backgroundColor: Colors.teal,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Stack(children: [
              GestureDetector(
                  onDoubleTap: _handlelike,
                  child: Image.network(
                    widget.image,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.5,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        showlike = true;
                        return child;
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                    errorBuilder: (context, error, stackTrace) => const Center(
                        heightFactor: 20, child: Text('No image to show')),
                  )),
              Positioned(
                  bottom: 15,
                  right: 15,
                  child: IconButton(
                    icon: Icon(Icons.favorite,
                        size: 50, color: liked ? Colors.red : Colors.grey),
                    onPressed: _handlelike,
                  ))
            ]),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            const Padding(
                padding: EdgeInsets.all(20),
                child: Text("Description",
                    style: TextStyle(fontWeight: FontWeight.w900))),
            Padding(
                padding: const EdgeInsets.all(20),
                child: Text(widget.description)),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("ksh ${widget.price}"),
                  ElevatedButton(
                      onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Checkout(amount: widget.price,productId: widget.id,image:widget.image)))
                          },
                      child: const Text("order now")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}