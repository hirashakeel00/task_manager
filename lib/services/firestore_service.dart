import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {

    await firestore.collection('users').add({
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {

    QuerySnapshot snapshot =
        await firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

    if (snapshot.docs.isEmpty) {
      return false;
    }

    var user = snapshot.docs.first;

    return user['password'] == password;
  }
}