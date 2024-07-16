import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanshop/models/artist_model.dart';
import 'package:fanshop/models/product_model.dart';
import 'package:fanshop/models/user_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUser(UserModel user) async {
    _db.collection('users').add(user.toJson());
  }

  Future<void> addProduct(ProductRequestModel product) async {
    try {
      _db.collection('products').add(product.toJson());
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> editProduct(ProductRequestModel product, String id) async {
    try {
      _db.collection('products').doc(id).update(product.toJson());
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      _db.collection('products').doc(id).delete();
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<List<ArtistModel>> fetchArtists() async {
    QuerySnapshot querySnapshot = await _db.collection('artists').get();

    return querySnapshot.docs
        .map((doc) => ArtistModel.fromFirestore(doc))
        .toList();
  }

  Future<List<ProductModel>> fetchProducts() async {
    QuerySnapshot querySnapshot = await _db.collection('products').get();

    return querySnapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc))
        .toList();
  }

  Future<List<ProductModel>> fetchTrendingProducts() async {
    QuerySnapshot querySnapshot = await _db
        .collection('products')
        .where('favoritesCount', isGreaterThanOrEqualTo: 100)
        .get();

    return querySnapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc))
        .toList();
  }

  Future<List<ProductModel>> fetchFavArtistProducts(String uid) async {
    try {
      print("Fetching fav artist products for user: $uid");
      QuerySnapshot userSnapshot =
          await _db.collection('users').where('uid', isEqualTo: uid).get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot document = userSnapshot.docs.first;
        List<dynamic>? preferences = document.get('preferences');

        QuerySnapshot productSnapshot = await _db
            .collection('products')
            .where('artist', whereIn: preferences)
            .get();

        List<ProductModel> products = productSnapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList();
        return products;
      } else {
        return [];
      }
    } catch (e) {
      print("Error: $e");
    }
    return [];
  }

  Future<String> getUsersPreferences(String uid) async {
    try {
      QuerySnapshot userSnapshot =
          await _db.collection('users').where('uid', isEqualTo: uid).get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot document = userSnapshot.docs.first;
        List<dynamic>? preferences = document.get('preferences');

        if (preferences != null) {
          String preferencesString = preferences.join(', ');
          return preferencesString;
        } else {
          return "";
        }
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  Future<List<ProductModel>> fetchOfficialMerchandise() async {
    try {
      QuerySnapshot productSnapshot = await _db
          .collection('products')
          .where('type', isEqualTo: "Official Merchandise")
          .get();
      List<ProductModel> products = productSnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
      return products;
    } catch (e) {
      print("Error: $e");
    }
    return [];
  }

  Future<List<ProductModel>> fetchFanmadeMerchandise() async {
    try {
      QuerySnapshot productSnapshot = await _db
          .collection('products')
          .where('type', isEqualTo: "Fanmade")
          .get();
      List<ProductModel> products = productSnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
      return products;
    } catch (e) {
      print("Error: $e");
    }
    return [];
  }

  Future<ProductModel> fetchProductById(String id) async {
    try {
      DocumentSnapshot doc = await _db.collection('products').doc(id).get();
      return ProductModel.fromFirestore(doc);
    } catch (e) {
      print("Error: $e");
    }
    return ProductModel();
  }

  Future<UserModel> fetchUser(String uid) async {
    try {
      QuerySnapshot userSnapshot =
          await _db.collection('users').where('uid', isEqualTo: uid).get();
      UserModel user = UserModel.fromFirestore(userSnapshot.docs.first);
      return user;
    } catch (e) {
      print("Error: $e");
    }
    return UserModel(uid: "", username: "", name: "", email: "");
  }

  Future<List<ProductModel>> fetchProductsBySearch(String query) async {
    try {
      QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('productName', isGreaterThanOrEqualTo: query)
          .get();
      QuerySnapshot artistSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('artist', isGreaterThanOrEqualTo: query)
          .get();

      List<ProductModel> products = [];
      products.addAll(productSnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList());
      products.addAll(artistSnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList());

      return products;
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<List<ProductModel>> fetchProductsByArtist(String artist) async {
    try {
      QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('artist', isEqualTo: artist)
          .get();

      List<ProductModel> products = productSnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
      return products;
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<List<ProductModel>> fetchProductsByUser(String uid) async {
    try {
      print("Fetching products by user: $uid");
      QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('createdBy', isEqualTo: uid)
          .get();

      print("Product snapshot: $productSnapshot");

      return productSnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}
