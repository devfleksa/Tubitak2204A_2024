import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  String username;
  final String email;
  final String userType;
  String imagePath;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.userType,
    required this.imagePath,
  });

  static UserModel empty() => UserModel(
        id: '',
        username: '',
        email: '',
        userType: '',
        imagePath: '',
      );

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'userType': userType,
      'imagePath': imagePath,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return UserModel(
        id: document.id,
        username: data['username'] ?? '',
        email: data['email'] ?? '',
        userType: data['userType'] ?? '',
        imagePath: data['imagePath'] ?? '',
      );
    } else {
      return UserModel.empty();
    }
  }
}
