import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:ninja_coder_employee_demo/features/employee_list/data/models/employee.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:ninja_coder_employee_demo/features/employee_list/data/datasources/employee_datasource.dart';

void main() {
  final getIt = GetIt.instance;
  late EmployeeDatasource datasource;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    getIt.registerSingleton<EmployeeDatasource>(
        EmployeeDatasource(dbName: 'employee_datasource_test.db'));
  });

  setUp(() async {
    datasource = getIt<EmployeeDatasource>();
    await datasource.clearDatabase();
  });

  group('CRUD operations', () {
    test('insert and retrieve employee', () async {
      final employee = Employee(
          id: 1,
          name: 'John Doe',
          role: 'Developer',
          joiningDate: DateTime.now());
      await datasource.insertEmployee(employee);

      final employees = await datasource.getEmployees();
      expect(employees, isNotEmpty);
      expect(employees.first.id, employee.id);
      expect(employees.first.name, employee.name);
      expect(employees.first.role, employee.role);
    });

    test('update employee', () async {
      final employee = Employee(
          id: 1,
          name: 'John Doe',
          role: 'Developer',
          joiningDate: DateTime.now());
      await datasource.insertEmployee(employee);

      final updatedEmployee = Employee(
          id: 1,
          name: 'John Doe',
          role: 'Manager',
          joiningDate: DateTime.now());
      await datasource.updateEmployee(updatedEmployee);

      final employees = await datasource.getEmployees();
      expect(employees, isNotEmpty);
      expect(employees.first.role, 'Manager');
    });

    test('delete employee', () async {
      final employee = Employee(
          id: 1,
          name: 'John Doe',
          role: 'Developer',
          joiningDate: DateTime.now());
      await datasource.insertEmployee(employee);

      await datasource.deleteEmployee(employee.id);

      final employees = await datasource.getEmployees();
      expect(employees, isEmpty);
    });

    test('get active employees', () async {
      final employee1 = Employee(
          id: 1,
          name: 'John Doe',
          role: 'Developer',
          joiningDate: DateTime.now());
      final employee2 = Employee(
          id: 2,
          name: 'Jane Doe',
          role: 'Manager',
          joiningDate: DateTime.now(),
          leavingDate: DateTime.now());
      await datasource.insertEmployee(employee1);
      await datasource.insertEmployee(employee2);

      final activeEmployees = await datasource.getActiveEmployees();
      expect(activeEmployees, isNotEmpty);
      expect(activeEmployees.length, 1);
      expect(activeEmployees.first.id, employee1.id);
    });

    test('get former employees', () async {
      final employee1 = Employee(
          id: 1,
          name: 'John Doe',
          role: 'Developer',
          joiningDate: DateTime.now());
      final employee2 = Employee(
          id: 2,
          name: 'Jane Doe',
          role: 'Manager',
          joiningDate: DateTime.now(),
          leavingDate: DateTime.now());
      await datasource.insertEmployee(employee1);
      await datasource.insertEmployee(employee2);

      final formerEmployees = await datasource.getFormerEmployees();
      expect(formerEmployees, isNotEmpty);
      expect(formerEmployees.length, 1);
      expect(formerEmployees.first.id, employee2.id);
    });
  });

  tearDownAll(() async {
    await datasource.close();
  });
}
