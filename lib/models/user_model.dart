import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? username;
  String? name;
  String? email;

  UserModel({
    required this.uid,
    required this.username,
    required this.name,
    required this.email,
  });

  UserModel.fromMap(Map<String, dynamic> map)
      : uid = map['uid'],
        username = map['username'],
        name = map['name'],
        email = map['email'];

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'name': name,
      'email': email,
    };
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      username: data['username'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
    );
  }
}
