import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mana_driver/Driver/D_Models/Driver_Model.dart';

class DriverViewModel extends ChangeNotifier {
  bool isLoading = false;
  DriverModel driver = DriverModel();

  Future<String> uploadImage(File file, String path) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> saveDriver() async {
    isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection("drivers")
          .add(driver.toJson());
    } catch (e) {
      debugPrint("Error saving driver: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  bool verifyOtp(String otp) => otp == "1234";
}
