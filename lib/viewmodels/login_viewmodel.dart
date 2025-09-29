import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/models/loginState.dart';

import '../services/repository.dart';

class LoginViewModel extends ChangeNotifier {
  final RepositoryData _repository;
  Map<String, dynamic>? _loggedInUser;
  Map<String, dynamic>? get loggedInUser => _loggedInUser;
  LoginViewModel(this._repository);

  LoginState _state = LoginState();
  LoginState get state => _state;

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "India",
    e164Key: "",
  );

  void setCountry(Country country) {
    selectedCountry = country;
    notifyListeners();
  }

  Future<void> checkPhoneAndSendOtp({
    required String phoneNumber,
    required BuildContext context,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
  }) async {
    if (phoneNumber.isEmpty || phoneNumber.length < 10) {
      _state = _state.copyWith(
        errorMessage: "Please enter a valid phone number",
      );
      notifyListeners();
      return;
    }

    _state = _state.copyWith(isLoading: true, errorMessage: '');
    notifyListeners();

    final exists = await _repository.checkUserExists(phoneNumber);

    if (!exists) {
      _state = _state.copyWith(
        isLoading: false,
        isNumberValid: false,
        errorMessage: "User not found. Please register first.",
      );
      notifyListeners();
      return;
    }

    final fullPhoneNumber = "+${selectedCountry.phoneCode}$phoneNumber";

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: fullPhoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        debugPrint("✅ verificationCompleted (auto-retrieved)");
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint(" verificationFailed: ${e.code} - ${e.message}");
        _state = _state.copyWith(isLoading: false);
        notifyListeners();
        onError(e.message ?? "Verification failed");
      },
      codeSent: (String verificationId, int? resendToken) {
        _state = _state.copyWith(isLoading: false, isNumberValid: true);
        notifyListeners();
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint("⏱️ Auto-retrieval timed out");
      },
    );
  }

  // Future<void> fetchLoggedInUser(String phoneNumber) async {
  //   final snapshot =
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .where('phone', isEqualTo: phoneNumber)
  //           .limit(1)
  //           .get();

  //   if (snapshot.docs.isNotEmpty) {
  //     final userData = snapshot.docs.first.data();
  //     _loggedInUser = userData;
  //     notifyListeners();
  //   }
  // }

  // Future<void> fetchLoggedInUser(String phoneNumber) async {
  //   try {
  //     final snapshot =
  //         await FirebaseFirestore.instance
  //             .collection('users')
  //             .where('phone', isEqualTo: phoneNumber)
  //             .limit(1)
  //             .get();

  //     if (snapshot.docs.isNotEmpty) {
  //       final userData = snapshot.docs.first.data();

  //       _loggedInUser = userData;
  //       notifyListeners();

  //       await SharedPrefServices.setUserId(userData['userId'] ?? "");
  //       await SharedPrefServices.setRoleCode(userData['roleCode'] ?? "");
  //       await SharedPrefServices.setFirstName(userData['firstName'] ?? "");
  //       await SharedPrefServices.setLastName(userData['lastName'] ?? "");
  //       await SharedPrefServices.setEmail(userData['email'] ?? "");
  //       await SharedPrefServices.setNumber(userData['phone'] ?? "");
  //       await SharedPrefServices.setCountryCode(userData['countryCode'] ?? "");
  //       await SharedPrefServices.setDocID(snapshot.docs.first.id);
  //       await SharedPrefServices.setislogged(false);

  //       print("User details stored in SharedPreferences");
  //     } else {
  //       print("No user found for phone: $phoneNumber");
  //     }
  //   } catch (e) {
  //     print("Error in fetchLoggedInUser: $e");
  //   }
  // }
  Future<void> fetchLoggedInUser(String phoneNumber) async {
    try {
      final driverSnap =
          await FirebaseFirestore.instance
              .collection('drivers')
              .where('phone', isEqualTo: normalizedPhone(phoneNumber))
              .limit(1)
              .get();

      if (driverSnap.docs.isNotEmpty) {
        final userData = driverSnap.docs.first.data();
        _loggedInUser = userData;
        notifyListeners();

        await SharedPrefServices.setRoleCode("Driver");
        await SharedPrefServices.setUserId(userData['driverId'] ?? "");
        await SharedPrefServices.setProfileImage(userData['profileUrl'] ?? "");

        await SharedPrefServices.setFirstName(userData['firstName'] ?? "");
        await SharedPrefServices.setLastName(userData['lastName'] ?? "");
        await SharedPrefServices.setEmail(userData['email'] ?? "");
        await SharedPrefServices.setNumber(userData['phone'] ?? "");
        await SharedPrefServices.setCountryCode(userData['countryCode'] ?? "");
        await SharedPrefServices.setDOB(userData['dob'] ?? "");
        await SharedPrefServices.setvehicleType(userData['vehicleType'] ?? "");
        await SharedPrefServices.setdrivingLicence(
          userData['licenceNumber'] ?? "",
        );
        await SharedPrefServices.setlicenceFront(
          userData['licenceFrontUrl'] ?? "",
        );
        await SharedPrefServices.setlicenceBack(
          userData['licenceBackUrl'] ?? "",
        );
        if (userData['bankAccount'] != null) {
          final bankData = userData['bankAccount'] as Map<String, dynamic>;

          await SharedPrefServices.setbankNmae(bankData['bankName'] ?? "");
          await SharedPrefServices.setaccountNumber(
            bankData['accountNumber'] ?? "",
          );
          await SharedPrefServices.setaccountHolderName(
            bankData['holderName'] ?? "",
          );
          await SharedPrefServices.setbranchName(bankData['branch'] ?? "");
          await SharedPrefServices.setifscCode(bankData['ifsc'] ?? "");
        }

        await SharedPrefServices.setDocID(driverSnap.docs.first.id);

        await SharedPrefServices.setislogged(false);

        print("Driver details stored in SharedPreferences");
        return;
      }

      // If not driver → check owners (users collection)
      final ownerSnap =
          await FirebaseFirestore.instance
              .collection('users')
              .where('phone', isEqualTo: normalizedPhone(phoneNumber))
              .limit(1)
              .get();

      if (ownerSnap.docs.isNotEmpty) {
        final userData = ownerSnap.docs.first.data();
        _loggedInUser = userData;
        notifyListeners();

        await SharedPrefServices.setRoleCode("Owner"); // ✅ force Owner role
        await SharedPrefServices.setUserId(userData['userId'] ?? "");
        await SharedPrefServices.setFirstName(userData['firstName'] ?? "");
        await SharedPrefServices.setLastName(userData['lastName'] ?? "");
        await SharedPrefServices.setEmail(userData['email'] ?? "");
        await SharedPrefServices.setNumber(userData['phone'] ?? "");
        await SharedPrefServices.setCountryCode(userData['countryCode'] ?? "");
        await SharedPrefServices.setDocID(ownerSnap.docs.first.id);
        await SharedPrefServices.setislogged(false);

        print("Owner details stored in SharedPreferences");
        return;
      }

      print("❌ No user found in drivers or users collection for $phoneNumber");
    } catch (e) {
      print("Error in fetchLoggedInUser: $e");
    }
  }

  // void  updateUser(Map<String, dynamic> newUserData) {
  //   _loggedInUser = newUserData;
  //   notifyListeners();
  // }

  void updateUser(Map<String, dynamic> newUserData) {
    _loggedInUser = newUserData;

    if (newUserData.containsKey('firstName')) {
      SharedPrefServices.setFirstName(newUserData['firstName']);
    }
    if (newUserData.containsKey('lastName')) {
      SharedPrefServices.setLastName(newUserData['lastName']);
    }
    if (newUserData.containsKey('email')) {
      SharedPrefServices.setEmail(newUserData['email']);
    }
    if (newUserData.containsKey('phone')) {
      SharedPrefServices.setNumber(newUserData['phone']);
    }

    notifyListeners();
  }

  String normalizedPhone(String phone) {
    if (phone.startsWith("+91")) return phone.substring(3); // remove +91
    return phone;
  }
}
