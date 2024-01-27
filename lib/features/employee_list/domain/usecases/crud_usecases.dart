import 'package:ninja_coder_employee_demo/features/employee_list/data/datasources/employee_datasource.dart';
import 'package:get_it/get_it.dart';

import '../../data/models/employee.dart';

class InsertEmployee {
  final EmployeeDatasource datasource = GetIt.instance<EmployeeDatasource>();

  Future<int> call(Employee employee) {
    return datasource.insertEmployee(employee);
  }
}

class GetEmployees {
  final EmployeeDatasource datasource = GetIt.instance<EmployeeDatasource>();

  Future<List<Employee>> call() {
    return datasource.getEmployees();
  }
}

class GetActiveEmployees {
  final EmployeeDatasource datasource = GetIt.instance<EmployeeDatasource>();

  Future<List<Employee>> call() {
    return datasource.getActiveEmployees();
  }
}

class GetFormerEmployees {
  final EmployeeDatasource datasource = GetIt.instance<EmployeeDatasource>();

  Future<List<Employee>> call() {
    return datasource.getFormerEmployees();
  }
}

class UpdateEmployee {
  final EmployeeDatasource datasource = GetIt.instance<EmployeeDatasource>();

  Future<int> call(Employee employee) {
    return datasource.updateEmployee(employee);
  }
}

class DeleteEmployee {
  final EmployeeDatasource datasource = GetIt.instance<EmployeeDatasource>();

  Future<int> call(int id) {
    return datasource.deleteEmployee(id);
  }
}
