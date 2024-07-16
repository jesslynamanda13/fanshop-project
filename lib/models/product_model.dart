import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? id;
  String? productName;
  String? artist;
  int? favoritesCount;
  String? imageUrl;
  String? type;
  int? price;
  String? location;
  int? stock;
  String? createdBy;
  String? description;

  ProductModel({
    this.id,
    this.productName,
    this.artist,
    this.favoritesCount,
    this.imageUrl,
    this.type,
    this.price,
    this.location,
    this.stock,
    this.createdBy,
    this.description,
  });

  ProductModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        productName = map['productName'],
        artist = map['artist'],
        favoritesCount = map['favoritesCount'],
        imageUrl = map['imageUrl'],
        type = map['type'],
        price = map['price'],
        location = map['location'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'artist': artist,
      'favoritesCount': favoritesCount,
      'imageUrl': imageUrl,
      'type': type,
      'price': price,
      'location': location,
      'stock': stock,
      'createdBy': createdBy,
      'description': description,
    };
  }

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      productName: data['productName'] ?? '',
      artist: data['artist'] ?? '',
      favoritesCount: data['favoritesCount'] ?? 0,
      imageUrl: data['imageUrl'] ?? '',
      type: data['type'] ?? '',
      price: data['price'] ?? 0,
      location: data['location'] ?? '',
      stock: data['stock'] ?? 0,
      createdBy: data['createdBy'] ?? '',
      description: data['description'] ?? '',
    );
  }
}

class ProductRequestModel {
  final String productName;
  final String artist;
  final int price;
  final String description;
  final String imageUrl;
  final int stock;
  final String type;
  final String location;
  final String createdBy;
  ProductRequestModel(
      {required this.productName,
      required this.artist,
      required this.price,
      required this.description,
      required this.imageUrl,
      required this.stock,
      required this.type,
      required this.location,
      required this.createdBy});

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'artist': artist,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'stock': stock,
      'type': type,
      'location': location,
      'createdBy': createdBy
    };
  }

  factory ProductRequestModel.fromJson(Map<String, dynamic> json) {
    return ProductRequestModel(
      productName: json['productName'],
      artist: json['artist'],
      price: json['price'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      stock: json['stock'],
      type: json['type'],
      location: json['location'],
      createdBy: json['createdBy'],
    );
  }
}
