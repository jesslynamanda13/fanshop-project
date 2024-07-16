import 'package:fanshop/models/artist_model.dart';
import 'package:fanshop/models/product_model.dart';
import 'package:fanshop/services/firebase_service.dart';
import 'package:fanshop/widgets/product_card.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  FirebaseService firebaseService = FirebaseService();
  late Future<List<ProductModel>> products;
  Future<List<ProductModel>>? _searchProductsFuture;
  Future<List<ArtistModel>>? _searchArtistsFuture;
  String? selectedArtist;
  @override
  void initState() {
    super.initState();
    fetchArtists();
    getAllProducts();
  }

  void getAllProducts() {
    setState(() {
      products = firebaseService.fetchProducts();
    });
  }

  void searchByQuery(String query) {
    setState(() {
      if (query.isNotEmpty) {
        _searchProductsFuture = products.then((productList) => productList
            .where((product) =>
                product.productName!
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                product.artist!.toLowerCase().contains(query.toLowerCase()))
            .toList());
      } else {
        _searchProductsFuture = products;
      }
    });
  }

  void searchByArtist(String artistName) {
    setState(() {
      _searchProductsFuture = firebaseService.fetchProductsByArtist(artistName);
    });
  }

  void fetchArtists() {
    setState(() {
      _searchArtistsFuture = firebaseService.fetchArtists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _searchController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20.0,
                        ),
                        hintText: "Search for artists or merchandises",
                        hintStyle: TextStyle(
                          fontFamily: "DM Sans",
                          color: Color(0xFFA2A2A2),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                        fillColor: Color(0xFF303030),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Color(0xFFA2A2A2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: () {
                      searchByQuery(_searchController.text);
                    },
                    child: const Icon(Icons.search, color: Colors.white),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                "Search by artists",
                style: TextStyle(
                  color: const Color.fromARGB(255, 243, 176, 255),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.0),
              FutureBuilder<List<ArtistModel>>(
                future: _searchArtistsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No artists found.'));
                  } else {
                    return Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: snapshot.data!.map((artist) {
                        return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                  color: selectedArtist == artist.name
                                      ? Color.fromARGB(255, 255, 253, 150)
                                      : Colors.white),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                selectedArtist = artist.name;
                                searchByArtist(artist.name);
                              },
                              child: Text(
                                artist.name,
                                style: TextStyle(
                                  color: selectedArtist == artist.name
                                      ? Color.fromARGB(255, 255, 253, 150)
                                      : Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ));
                      }).toList(),
                    );
                  }
                },
              ),
              if (_searchProductsFuture != null)
                FutureBuilder<List<ProductModel>>(
                  future: _searchProductsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No products found.'));
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
                          return ProductCard(product: snapshot.data![index]);
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
