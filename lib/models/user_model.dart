class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;
  final double totalBalance;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    required this.totalBalance,
  });

  String get firstName => name.split(' ').first;

  UserModel copyWith({
    String? name,
    String? email,
    String? role,
    String? avatarUrl,
    double? totalBalance,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalBalance: totalBalance ?? this.totalBalance,
    );
  }

  static const UserModel mock = UserModel(
    id: 'u1',
    name: 'Tayyab Sohail',
    email: 'tayyabsohailabd@gmail.com',
    role: 'UX/UI Designer',
    totalBalance: 1200.0,
  );
}