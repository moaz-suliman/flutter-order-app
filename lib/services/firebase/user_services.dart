import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore database = FirebaseFirestore.instance;

  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    await database.collection('users').doc(uid).set(data);
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    return await database.collection('users').doc(uid).get();
  }

  Future<void> updateUserName({required String uid, required String name}) async {
    await database.collection('users').doc(uid).update({
      'name': name.trim(),
    });
  }
}