import 'package:fanshop/models/product_model.dart';
import 'package:fanshop/pages/product_edit_form_page.dart';
import 'package:fanshop/services/firebase_service.dart';
import 'package:flutter/material.dart';

class ProductEditPage extends StatefulWidget {
  final ProductModel product;
  final String uid;
  final String username;
  final String name;
  const ProductEditPage(
      {super.key,
      required this.product,
      required this.uid,
      required this.username,
      required this.name});

  @override
  _ProductEditPageState createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  String _formatPrice(int? price) {
    String priceString = price.toString();
    String formattedPrice = '';
    int counter = 0;

    for (int i = priceString.length - 1; i >= 0; i--) {
      counter++;
      formattedPrice = priceString[i] + formattedPrice;
      if (counter == 3 && i != 0) {
        formattedPrice = '.' + formattedPrice;
        counter = 0;
      }
    }
    return formattedPrice;
  }

  void deleteProduct(String id) {
    FirebaseService firebase = FirebaseService();
    firebase.deleteProduct(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                      child: Image.network(widget.product.imageUrl!,
                          height: 300.0)),
                  const SizedBox(height: 20.0),
                  Text(
                    widget.product.productName!,
                    style: const TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    "Rp. ${_formatPrice(widget.product.price)}",
                    style: const TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 136, 81, 0)),
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                              color:
                                  widget.product.type == 'Official Merchandise'
                                      ? Colors.green
                                      : Color.fromARGB(255, 235, 129, 0)),
                        ),
                        child: Text(
                          widget.product.type!,
                          style: TextStyle(
                            color: widget.product.type == 'Official Merchandise'
                                ? Colors.green
                                : Color.fromARGB(255, 235, 129, 0),
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(color: Colors.purple),
                        ),
                        child: Text(
                          widget.product.artist!,
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.purple,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text("Based in ${widget.product.location}",
                      style: const TextStyle(
                          fontFamily: "DM Sans",
                          fontSize: 12.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400)),
                  const SizedBox(height: 10.0),
                  Text("🧺 Stock: ${widget.product.stock}",
                      style: const TextStyle(
                          fontFamily: "DM Sans",
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w400)),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProductFormPage(
                                        uid: widget.uid,
                                        username: widget.username,
                                        name: widget.name,
                                        product: widget.product),
                                  ),
                                ),
                              },
                          child: Text("Edit")),
                      SizedBox(width: 10.0),
                      ElevatedButton(
                          onPressed: () => {
                                deleteProduct(widget.product.id!),
                                Navigator.pop(context)
                              },
                          child: Text("Delete",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600))),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  const Text("Product Description",
                      style: TextStyle(
                          fontFamily: "DM Sans",
                          fontSize: 16.0,
                          color: Color.fromARGB(255, 136, 81, 0),
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10.0),
                  Text(widget.product.description!,
                      style: const TextStyle(
                          fontFamily: "DM Sans",
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w400)),
                  const SizedBox(height: 40.0),
                ])));
  }
}
