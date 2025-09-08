class UserModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String roleCode;

  final String email;
  final String phone;
  final String countryCode;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.roleCode,
    required this.email,
    required this.phone,
    required this.countryCode,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'firstName': firstName,
    'lastName': lastName,
    'roleCode': roleCode,
    'email': email,
    'phone': phone,
    'countryCode': countryCode,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      roleCode: map['roleCode'] ?? '',
      userId: map['userId'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',

      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      countryCode: map['countryCode'] ?? '',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
