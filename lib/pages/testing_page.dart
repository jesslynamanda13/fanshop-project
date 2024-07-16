import 'package:fanshop/models/product_model.dart';
import 'package:fanshop/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:fanshop/services/firebase_service.dart';

class TestingPage extends StatefulWidget {
  const TestingPage({Key? key}) : super(key: key);

  @override
  _TestingPageState createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  FirebaseService firebaseService = FirebaseService();
  String uid = "qjYBFiEeP2VXYmjsyLrxzpfvGrx1";
  late Future<List<ProductModel>> _artistPreferencesProductsFuture;

  @override
  void initState() {
    super.initState();
    _artistPreferencesProductsFuture = fetchArtistPreferencesProducts();
  }

  Future<List<ProductModel>> fetchArtistPreferencesProducts() async {
    return firebaseService.fetchFavArtistProducts(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ProductModel>>(
        future: _artistPreferencesProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No trending products found.'));
          } else {
            return Container(
              height: 250, // Adjust the height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: snapshot.data![index]);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
