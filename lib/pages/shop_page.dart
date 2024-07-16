import 'package:fanshop/arguments/user_argument.dart';
import 'package:fanshop/models/product_model.dart';
import 'package:fanshop/services/firebase_service.dart';
import 'package:fanshop/widgets/navigation_bar.dart';
import 'package:fanshop/widgets/product_card.dart';
import 'package:fanshop/widgets/product_edit_card.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  final String uid;
  final String username;
  final String name;
  const ShopPage(
      {Key? key, required this.uid, required this.username, required this.name})
      : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  void addProduct() {
    Navigator.pushNamed(context, '/addproductpage',
        arguments: UserArgument(widget.uid, widget.username, widget.name));
  }

  @override
  void initState() {
    super.initState();
    products = fetchUsersProducts();
  }

  FirebaseService firebase = FirebaseService();
  late Future<List<ProductModel>> products;

  Future<List<ProductModel>> fetchUsersProducts() {
    return firebase.fetchProductsByUser(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Text(
                "Your shop",
                style: const TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 28.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    addProduct();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE0B0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 12.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Center the content horizontally
                    children: [
                      Icon(Icons.add, color: Colors.black),
                      const SizedBox(width: 10.0),
                      Text(
                        "Add Product",
                        style: const TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                "Your products",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10.0),
              FutureBuilder<List<ProductModel>>(
                future: products,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error}',
                            style: TextStyle(color: Colors.white)));
                  } else {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.7, // Adjust as needed
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ProductEditCard(
                            uid: widget.uid,
                            username: widget.username,
                            name: widget.name,
                            product: snapshot.data![index]);
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
