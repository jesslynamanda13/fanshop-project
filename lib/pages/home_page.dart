import 'package:fanshop/arguments/user_argument.dart';
import 'package:fanshop/models/product_model.dart';
import 'package:fanshop/services/firebase_service.dart';
import 'package:fanshop/widgets/navigation_bar.dart';
import 'package:fanshop/widgets/product_card.dart';
import 'package:fanshop/widgets/product_edit_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String uid;
  final String username;
  final String name;
  const HomePage({
    Key? key,
    required this.uid,
    required this.username,
    required this.name,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseService firebaseService = FirebaseService();
  String? preferences;

  @override
  void initState() {
    super.initState();
    _artistPreferencesProductsFuture = fetchArtistPreferencesProducts();
    _trendingProductsFuture = fetchTrendingProducts();
    _officialProductsFuture = fetchOfficialProducts();
    _fanmadeProductsFuture = fetchFanmadeProducts();
    fetchUserPreferences();
  }

  late Future<List<ProductModel>> _trendingProductsFuture;
  late Future<List<ProductModel>> _artistPreferencesProductsFuture;
  late Future<List<ProductModel>> _officialProductsFuture;
  late Future<List<ProductModel>> _fanmadeProductsFuture;
  Future<List<ProductModel>> fetchTrendingProducts() async {
    return firebaseService.fetchTrendingProducts();
  }

  Future<List<ProductModel>> fetchArtistPreferencesProducts() async {
    return firebaseService.fetchFavArtistProducts(widget.uid);
  }

  Future<List<ProductModel>> fetchOfficialProducts() async {
    return firebaseService.fetchOfficialMerchandise();
  }

  Future<List<ProductModel>> fetchFanmadeProducts() async {
    return firebaseService.fetchFanmadeMerchandise();
  }

  void fetchUserPreferences() async {
    preferences = await firebaseService.getUsersPreferences(widget.uid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hi, ${widget.name}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Quicksand",
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/searchpage');
                        },
                        child: const Icon(
                          color: Colors.white,
                          Icons.search,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed("/shoppage",
                              arguments: UserArgument(
                                  widget.uid, widget.username, widget.name));
                        },
                        child: const Icon(
                          color: Colors.white,
                          Icons.shop_2,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Trending stuff",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Quicksand",
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Explore the hottest items 🔥",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: "DM Sans",
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<ProductModel>>(
                future: _trendingProductsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No trending products found.'));
                  } else {
                    return Container(
                      height: 250,
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
              const SizedBox(height: 20),
              const Text(
                "Based on your favorite artists 🤟🏻",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Quicksand",
                ),
              ),
              const SizedBox(height: 5),
              FutureBuilder<String?>(
                future: firebaseService.getUsersPreferences(widget.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    String? preferences = snapshot.data;
                    return Text(
                      preferences ?? "", // Handle null case
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        fontFamily: "DM Sans",
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<ProductModel>>(
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
              const SizedBox(height: 20),
              const Text(
                "Official Merchandises",
                style: TextStyle(
                  color: Color.fromARGB(255, 147, 232, 149),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Quicksand",
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Officially official - sourced through official channels",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: "DM Sans",
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<ProductModel>>(
                future: _officialProductsFuture,
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
              const SizedBox(height: 20),
              const Text(
                "Fanmade Merchandise",
                style: TextStyle(
                  color: Color.fromARGB(255, 235, 129, 0),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Quicksand",
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Curated by Fans, for Fans",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: "DM Sans",
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<ProductModel>>(
                future: _fanmadeProductsFuture,
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
            ],
          ),
        ),
      ),
    );
  }
}
