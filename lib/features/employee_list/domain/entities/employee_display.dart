import 'package:intl/intl.dart';

import '../../data/models/employee.dart';

class EmployeeDisplay {
  final int id;
  final String name;
  final String role;
  final String joiningDate;
  final String? leavingDate;

  EmployeeDisplay({
    required this.id,
    required this.name,
    required this.role,
    required this.joiningDate,
    this.leavingDate,
  });

  static EmployeeDisplay fromEmployee(Employee employee) {
    final dateFormat = DateFormat('dd MMM yyyy');
    return EmployeeDisplay(
      id: employee.id,
      name: employee.name,
      role: employee.role,
      joiningDate: dateFormat.format(employee.joiningDate),
      leavingDate: employee.leavingDate != null
          ? dateFormat.format(employee.leavingDate!)
          : null,
    );
  }
}
