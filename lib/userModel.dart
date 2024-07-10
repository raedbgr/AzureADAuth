class UserModel {
  final String name;
  final String uniqueName;

  UserModel({
    required this.name,
    required this.uniqueName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      uniqueName: json['unique_name'],
    );
  }
}
