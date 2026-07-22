/// Data model representing a Donor user from the API.
///
/// Maps to the `DonorUser` schema:
/// ```json
/// { "id", "email", "name", "role", "isVerified", "createdAt" }
/// ```
class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;
  final bool isVerified;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.isVerified,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? 'DONOR',
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'role': role,
        'isVerified': isVerified,
        'createdAt': createdAt?.toIso8601String(),
      };

  /// First character of the name, used for avatar fallback.
  String get initial => name.isNotEmpty ? name[0].toUpperCase() : '?';
}
