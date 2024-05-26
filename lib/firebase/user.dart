import 'package:cloud_firestore/cloud_firestore.dart';

/// A class to represent a user with an email and uid.
class User {
  late String email;
  late String uid;

  User({required this.email, required this.uid});

  /// Sets the email of the user and updates Firestore.
  Future<void> setEmail(String email) async {
    this.email = email;
    await addToFirestore();
  }

  /// Sets the uid of the user and updates Firestore.
  Future<void> setUid(String uid) async {
    this.uid = uid;
    await addToFirestore();
  }

  Future<void> addToFirestore() async {
    // Reference to the Firestore collection "user"
    CollectionReference users = FirebaseFirestore.instance.collection('user');

    // Create or update the document with uid as the document ID
    await users.doc(uid).set({
      'email': email,
      'uid': uid,
    });
  }
}
