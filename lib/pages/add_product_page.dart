import 'package:fanshop/arguments/user_argument.dart';
import 'package:fanshop/models/artist_model.dart';
import 'package:fanshop/models/product_model.dart';
import 'package:fanshop/services/firebase_service.dart';
import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  final String uid;
  final String username;
  final String name;
  const AddProductPage(
      {Key? key, required this.uid, required this.username, required this.name})
      : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  late Future<List<ArtistModel>> artists;
  FirebaseService firebase = FirebaseService();
  String? selectedArtist;
  String? type;

  @override
  void initState() {
    super.initState();
    fetchArtists();
  }

  void fetchArtists() {
    artists = firebase.fetchArtists();
  }

  void addProduct() {
    ProductRequestModel product = ProductRequestModel(
      productName: _productNameController.text,
      artist: _artistController.text,
      price: int.parse(_priceController.text),
      description: _descriptionController.text,
      imageUrl: _imageUrlController.text,
      stock: int.parse(_stockController.text),
      type: _typeController.text,
      location: _locationController.text,
      createdBy: widget.uid,
    );

    firebase.addProduct(product);
    Navigator.of(context).pushNamed("/homepage",
        arguments: UserArgument(widget.uid, widget.username, widget.name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 40.0, right: 20.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Add Product",
                style: const TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 28.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              const Text(
                "Product name",
                style: TextStyle(
                  fontFamily: "DM Sans",
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _productNameController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  hintText: "Enter product name",
                  hintStyle: TextStyle(
                    fontFamily: "DM Sans",
                    color: Color(0xFFA2A2A2),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  fillColor: Color(0xFF303030),
                  filled: true,
                  prefixIcon: Icon(Icons.abc, color: Color(0xFFA2A2A2)),
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
              SizedBox(height: 20),
              const Text(
                "Artist",
                style: TextStyle(
                  fontFamily: "DM Sans",
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15.0),
              FutureBuilder<List<ArtistModel>>(
                future: artists,
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
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedArtist = artist.name;
                              _artistController.text = artist.name;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: selectedArtist == artist.name
                                    ? Color.fromARGB(255, 255, 253, 150)
                                    : Colors.white,
                              ),
                            ),
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
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              const Text(
                "Type",
                style: TextStyle(
                  fontFamily: "DM Sans",
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15),
              Wrap(spacing: 8.0, runSpacing: 8.0, children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      type = "Official Merchandise";
                      _typeController.text = "Official Merchandise";
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: type == "Official Merchandise"
                            ? Color.fromARGB(255, 255, 253, 150)
                            : Colors.white,
                      ),
                    ),
                    child: Text(
                      "Official Merchandise",
                      style: TextStyle(
                        color: type == "Official Merchandise"
                            ? Color.fromARGB(255, 255, 253, 150)
                            : Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      type = "Fanmade";
                      _typeController.text = "Fanmade";
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: type == "Fanmade"
                            ? Color.fromARGB(255, 255, 253, 150)
                            : Colors.white,
                      ),
                    ),
                    child: Text(
                      "Fanmade",
                      style: TextStyle(
                        color: type == "Fanmade"
                            ? Color.fromARGB(255, 255, 253, 150)
                            : Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ]),
              SizedBox(height: 20),
              const Text(
                "Price",
                style: TextStyle(
                  fontFamily: "DM Sans",
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _priceController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  hintText: "Enter price",
                  hintStyle: TextStyle(
                    fontFamily: "DM Sans",
                    color: Color(0xFFA2A2A2),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  fillColor: Color(0xFF303030),
                  filled: true,
                  prefixIcon:
                      Icon(Icons.price_change, color: Color(0xFFA2A2A2)),
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
              SizedBox(height: 20),
              const Text(
                "Location",
                style: TextStyle(
                  fontFamily: "DM Sans",
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _locationController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  hintText: "Enter your location",
                  hintStyle: TextStyle(
                    fontFamily: "DM Sans",
                    color: Color(0xFFA2A2A2),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  fillColor: Color(0xFF303030),
                  filled: true,
                  prefixIcon:
                      Icon(Icons.location_city, color: Color(0xFFA2A2A2)),
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
              SizedBox(height: 20),
              const Text(
                "Description",
                style: TextStyle(
                  fontFamily: "DM Sans",
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _descriptionController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  hintText: "Enter description",
                  hintStyle: TextStyle(
                    fontFamily: "DM Sans",
                    color: Color(0xFFA2A2A2),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  fillColor: Color(0xFF303030),
                  filled: true,
                  prefixIcon: Icon(Icons.description, color: Color(0xFFA2A2A2)),
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
              SizedBox(height: 20),
              const Text(
                "Stock",
                style: TextStyle(
                  fontFamily: "DM Sans",
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _stockController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  hintText: "Enter stock",
                  hintStyle: TextStyle(
                    fontFamily: "DM Sans",
                    color: Color(0xFFA2A2A2),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  fillColor: Color(0xFF303030),
                  filled: true,
                  prefixIcon: Icon(Icons.numbers, color: Color(0xFFA2A2A2)),
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
              SizedBox(height: 20),
              const Text(
                "Image URL",
                style: TextStyle(
                  fontFamily: "DM Sans",
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  hintText: "Enter Image URL",
                  hintStyle: TextStyle(
                    fontFamily: "DM Sans",
                    color: Color(0xFFA2A2A2),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  fillColor: Color(0xFF303030),
                  filled: true,
                  prefixIcon: Icon(Icons.image, color: Color(0xFFA2A2A2)),
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
              SizedBox(height: 40),
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
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
