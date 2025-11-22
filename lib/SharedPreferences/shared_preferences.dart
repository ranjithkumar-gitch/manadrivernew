import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefServices {
  static SharedPreferences? prefs;

  static const _keyuserId = 'userId';
  static const _keyfirstName = 'firstname';
  static const _keylastName = 'lastname';
  static const _keyemail = 'email';

  static const _keyprofileImage = 'profileimage';

  static const _keynumber = 'number';
  static const _keystatus = 'status';
  static const _keydocId = 'docID';
  static const _keyroleCode = 'roleCode';
  static const _keycountryCode = 'countryCode';
  static const _keydob = 'dob';
  static const _keydrivingLicence = 'drivingLicence';
  static const _keyvehicleType = 'vehicleType';
  static const _keylicenceFront = 'licenceFront';
  static const _keylicenceBack = 'licenceBack';
  static const _keyaccountHolderName = 'accountHolderName';
  static const _keyaccountNumber = 'accountNumber';
  static const _keyifscCode = 'ifscCode';
  static const _keybankName = 'bankName';
  static const _keybranchName = 'branchName';

  static const _keyislogged = 'islogged';

  static const _keysavelanguage = 'savelanguage ';

  static const _keyisOnline = 'isOnline';

  static Future init() async => prefs = await SharedPreferences.getInstance();

  static Future setislogged(bool islogged) async {
    await prefs!.setBool(_keyislogged, islogged);
  }

  static Future setisOnline(bool isOnline) async {
    await prefs!.setBool(_keyisOnline, isOnline);
  }

  static Future setSaveLanguage(String savelanguage) async =>
      await prefs!.setString(_keysavelanguage, savelanguage);

  static Future setUserId(String userId) async =>
      await prefs!.setString(_keyuserId, userId);
  static Future setProfileImage(String profileimage) async =>
      await prefs!.setString(_keyprofileImage, profileimage);

  static Future setlicenceFront(String licenceFront) async =>
      await prefs!.setString(_keylicenceFront, licenceFront);

  static Future setlicenceBack(String licenceBack) async =>
      await prefs!.setString(_keylicenceBack, licenceBack);

  static Future setaccountHolderName(String accountHolderName) async =>
      await prefs!.setString(_keyaccountHolderName, accountHolderName);

  static Future setaccountNumber(String accountNumber) async =>
      await prefs!.setString(_keyaccountNumber, accountNumber);
  static Future setifscCode(String ifscCode) async =>
      await prefs!.setString(_keyifscCode, ifscCode);
  static Future setbankNmae(String bankName) async =>
      await prefs!.setString(_keybankName, bankName);
  static Future setbranchName(String branchName) async =>
      await prefs!.setString(_keybranchName, branchName);

  static Future setDOB(String dob) async =>
      await prefs!.setString(_keydob, dob);
  static Future setdrivingLicence(String drivingLicence) async =>
      await prefs!.setString(_keydrivingLicence, drivingLicence);

  static Future setvehicleType(String vehicleType) async =>
      await prefs!.setString(_keyvehicleType, vehicleType);

  static Future setCountryCode(String countryCode) async =>
      await prefs!.setString(_keycountryCode, countryCode);

  static Future setRoleCode(String roleCode) async =>
      await prefs!.setString(_keyroleCode, roleCode);

  static Future setDocID(String docId) async =>
      await prefs!.setString(_keydocId, docId);

  static Future setNumber(String number) async =>
      await prefs!.setString(_keynumber, number);

  static Future setFirstName(String firstName) async =>
      await prefs!.setString(_keyfirstName, firstName);

  static Future setLastName(String lastName) async =>
      await prefs!.setString(_keylastName, lastName);

  static Future setEmail(String email) async =>
      await prefs!.setString(_keyemail, email);

  static Future setStatus(String status) async =>
      await prefs!.setString(_keystatus, status);

  // Getters

  static bool getislogged() => prefs!.getBool(_keyislogged) ?? false;
  static bool getisOnline() => prefs!.getBool(_keyisOnline) ?? false;
  static String? getUserId() => prefs!.getString(_keyuserId);
  static String? getSaveLanguage() => prefs!.getString(_keysavelanguage);
  static String? getdob() => prefs!.getString(_keydob);
  static String? getdrivingLicence() => prefs!.getString(_keydrivingLicence);
  static String? getvehicletypee() => prefs!.getString(_keyvehicleType);
  static String? getlicenceFront() => prefs!.getString(_keylicenceFront);
  static String? getlicenceBack() => prefs!.getString(_keylicenceBack);
  static String? getaccountHolderName() =>
      prefs!.getString(_keyaccountHolderName);
  static String? getaccountNumber() => prefs!.getString(_keyaccountNumber);
  static String? getifscCode() => prefs!.getString(_keyifscCode);
  static String? getbankNmae() => prefs!.getString(_keybankName);
  static String? getbranchName() => prefs!.getString(_keybranchName);

  static String? getFirstName() => prefs!.getString(_keyfirstName);

  static String? getCountryCode() => prefs!.getString(_keycountryCode);

  static String? getLastName() => prefs!.getString(_keylastName);

  static String? getEmail() => prefs!.getString(_keyemail);

  static String? getProfileImage() => prefs!.getString(_keyprofileImage);

  static String? getNumber() => prefs!.getString(_keynumber);
  static String? getDocId() => prefs!.getString(_keydocId);

  static String? getRoleCode() => prefs!.getString(_keyroleCode);

  static String? getStatus() => prefs!.getString(_keystatus);

  static Future<void> clearUserFromSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();

    await prefs!.setString(_keyuserId, "");
    await prefs!.setString(_keyfirstName, "");
    await prefs!.setString(_keylastName, "");
    await prefs!.setString(_keyemail, "");

    await prefs!.setString(_keyprofileImage, "");

    await prefs!.setString(_keynumber, "");
    await prefs!.setString(_keystatus, "");
    await prefs!.setString(_keyroleCode, "");
    await prefs!.setBool(_keyislogged, false);

    await prefs!.setString(_keydocId, "");

    print('User data reset in SharedPreferences.');
  }

  static getdocumentId() {}

  static Future getInstance() async {}
}
