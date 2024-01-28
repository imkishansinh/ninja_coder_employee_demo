import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/employee_display.dart';

class Employee extends Equatable {
  int id;
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

  void setId(int newId) {
    id = newId;
  }

  Map<String, dynamic> toMap({List<String>? ignore}) {
    final map = {
      'id': id,
      'name': name,
      'role': role,
      'joiningDate': joiningDate.toIso8601String(),
      'leavingDate': leavingDate?.toIso8601String(),
    };

    if (ignore != null) {
      for (var key in ignore) {
        map.remove(key);
      }
    }

    return map;
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

  factory Employee.fromEmployeeDisplay(EmployeeDisplay employeeDisplay) {
    final dateFormat = DateFormat('dd MMM yyyy');
    return Employee(
      id: employeeDisplay.id,
      name: employeeDisplay.name,
      role: employeeDisplay.role,
      joiningDate: dateFormat.parse(employeeDisplay.joiningDate),
      leavingDate: employeeDisplay.leavingDate != null
          ? dateFormat.parse(employeeDisplay.leavingDate ?? '')
          : null,
    );
  }

  @override
  List<Object> get props => [id, name, role, joiningDate, leavingDate ?? ''];
}
