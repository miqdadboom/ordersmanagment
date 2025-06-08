class EmployeeModel {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String distributionLine;
  final String role;

  EmployeeModel({
    this.id, //
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.distributionLine,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'distributionLine': distributionLine,
      'role': role,
    };
  }

  factory EmployeeModel.fromFirestore(String id, Map<String, dynamic> data) {
    return EmployeeModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      distributionLine: data['distributionLine'] ?? '',
      role: data['role'] ?? '',
    );
  }
}
