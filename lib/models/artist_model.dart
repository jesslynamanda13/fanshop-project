import 'package:cloud_firestore/cloud_firestore.dart';

class ArtistModel {
  late String name;
  late String imageUrl;

  ArtistModel({required this.name, required this.imageUrl});

  ArtistModel.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        imageUrl = map['imageUrl'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory ArtistModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ArtistModel(
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
