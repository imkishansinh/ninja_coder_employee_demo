class Employee {
  final int id;
  final String name;
  final String role;
  final DateTime joiningDate;
  final DateTime? leavingDate;

  Employee(
      {required this.id,
      required this.name,
      required this.role,
      required this.joiningDate,
      this.leavingDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'joiningDate': joiningDate.toIso8601String(),
      'leavingDate': leavingDate?.toIso8601String(),
    };
  }

  static Employee fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      role: map['role'],
      joiningDate: DateTime.parse(map['joiningDate']),
      leavingDate: map['leavingDate'] != null
          ? DateTime.parse(map['leavingDate'])
          : null,
    );
  }
}
