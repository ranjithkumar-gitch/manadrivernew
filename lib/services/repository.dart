import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class RepositoryData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser({
    required UserModel user,
    String collectionPrefix = 'users',
  }) async {
    final collectionName = 'users';
    final docRef = _firestore.collection(collectionName).doc();
    await docRef.set(user.toMap());
  }

  Future<bool> checkUserExists(String phoneNumber) async {
    final query =
        await _firestore
            .collection('users')
            .where('phone', isEqualTo: phoneNumber)
            .limit(1)
            .get();

    return query.docs.isNotEmpty;
  }

  Future<bool> isUserVerified(String phoneNumber) async {
    final query =
        await _firestore
            .collection('users')
            .where('phone', isEqualTo: phoneNumber)
            .limit(1)
            .get();

    if (query.docs.isNotEmpty) {
      final data = query.docs.first.data();
      return data['verified'] == true;
    }
    return false;
  }
}
