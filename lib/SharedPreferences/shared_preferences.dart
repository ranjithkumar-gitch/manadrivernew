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
  static const _keyislogged = 'islogged';
 

  static Future init() async => prefs = await SharedPreferences.getInstance();

  
  static Future setislogged(bool islogged) async {
    await prefs!.setBool(_keyislogged, islogged);
  }

  static Future setUserId(String userId) async =>
      await prefs!.setString(_keyuserId, userId);

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
  static String? getUserId() => prefs!.getString(_keyuserId);

  static String? getFirstName() => prefs!.getString(_keyfirstName);

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
