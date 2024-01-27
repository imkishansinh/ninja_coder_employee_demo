import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:ninja_coder_employee_demo/features/employee_list/data/datasources/employee_datasource.dart';
import 'package:ninja_coder_employee_demo/features/employee_list/data/models/employee.dart';
import 'package:ninja_coder_employee_demo/features/employee_list/domain/usecases/crud_usecases.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  final getIt = GetIt.instance;
  late EmployeeDatasource datasource;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    getIt.registerSingleton<EmployeeDatasource>(
        EmployeeDatasource(dbName: 'crud_usecases_test.db'));
  });

  setUp(() async {
    datasource = getIt<EmployeeDatasource>();
    await datasource.clearDatabase();
  });

  group('CRUD operations', () {
    test('insert, update, delete, and retrieve employees', () async {
      final employee = Employee(
          id: 1,
          name: 'John Doe',
          role: 'Developer',
          joiningDate: DateTime.now(),
          leavingDate: null);
      final insertEmployee = InsertEmployee();
      await insertEmployee(employee);

      final getEmployees = GetEmployees();
      var employees = await getEmployees();
      expect(employees, isNotEmpty);
      expect(employees.first.id, employee.id);
      expect(employees.first.name, employee.name);
      expect(employees.first.role, employee.role);

      final updateEmployee = UpdateEmployee();
      final updatedEmployee = Employee(
          id: 1,
          name: 'John Doe Updated',
          role: 'Developer',
          joiningDate: DateTime.now(),
          leavingDate: null);
      await updateEmployee(updatedEmployee);

      employees = await getEmployees();
      expect(employees.first.name, updatedEmployee.name);

      final deleteEmployee = DeleteEmployee();
      await deleteEmployee(employee.id);

      employees = await getEmployees();
      expect(employees, isEmpty);
    });

    test('get active and former employees', () async {
      final activeEmployee = Employee(
          id: 1,
          name: 'Active Employee',
          role: 'Developer',
          joiningDate: DateTime.now(),
          leavingDate: null);
      final formerEmployee = Employee(
          id: 2,
          name: 'Former Employee',
          role: 'Developer',
          joiningDate: DateTime.now(),
          leavingDate: DateTime.now());

      final insertEmployee = InsertEmployee();
      await insertEmployee(activeEmployee);
      await insertEmployee(formerEmployee);

      final getActiveEmployees = GetActiveEmployees();
      final activeEmployees = await getActiveEmployees();
      expect(activeEmployees, isNotEmpty);
      expect(activeEmployees.first.id, activeEmployee.id);

      final getFormerEmployees = GetFormerEmployees();
      final formerEmployees = await getFormerEmployees();
      expect(formerEmployees, isNotEmpty);
      expect(formerEmployees.first.id, formerEmployee.id);
    });
  });

  tearDownAll(() async {
    await datasource.close();
  });
}
