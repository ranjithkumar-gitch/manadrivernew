import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mana_driver/services/repository.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

class RegisterViewModel extends ChangeNotifier {
  final RepositoryData _firebaseService;
  bool _isLoading = false;
  String? _errorMessage;

  RegisterViewModel(this._firebaseService);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  Future<bool> register({
    required String fisrtName,
    required String lastName,
    required String email,
    required String phone,
    required String countryCode,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      if (fisrtName.trim().isEmpty) throw Exception('First name required');
      if (lastName.trim().isEmpty) throw Exception('Last name required');
      if (email.trim().isEmpty) throw Exception('Email required');
      if (phone.trim().isEmpty) throw Exception('Phone required');

      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      final totalCount = snapshot.docs.length;

      final now = DateTime.now();
      final formattedDate =
          "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}"
          "${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
      final generatedUserId = "Owner_$formattedDate";

      final id = const Uuid().v4();
      final user = UserModel(
        userId: generatedUserId,
        roleCode: "Owner",
        firstName: fisrtName.trim(),
        lastName: lastName.trim(),
        email: email.trim(),
        phone: phone.trim(),
        countryCode: countryCode,
        createdAt: DateTime.now(),
      );

      await _firebaseService.createUser(user: user, collectionPrefix: 'users');

      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }
}
