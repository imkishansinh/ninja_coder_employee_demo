import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../data/models/employee.dart';
import '../../domain/entities/employee_display.dart';
import '../../domain/usecases/crud_usecases.dart';

part 'employee_list_state.dart';

class EmployeeListCubit extends Cubit<EmployeeListState> {
  final GetEmployees getEmployees = GetIt.I<GetEmployees>();
  final GetActiveEmployees getActiveEmployees = GetIt.I<GetActiveEmployees>();
  final GetFormerEmployees getFormerEmployees = GetIt.I<GetFormerEmployees>();
  final InsertEmployee insertEmployee = GetIt.I<InsertEmployee>();
  final UpdateEmployee updateEmployee = GetIt.I<UpdateEmployee>();
  final DeleteEmployee deleteEmployee = GetIt.I<DeleteEmployee>();

  EmployeeListCubit() : super(EmployeeListInitial());

  Future<void> loadEmployees() async {
    emit(EmployeeListLoading());
    try {
      final employees = await getEmployees();
      final employeesDisplay =
          employees.map((e) => EmployeeDisplay.fromEmployee(e)).toList();
      emit(EmployeeListLoaded(employeesDisplay));
    } catch (e) {
      emit(EmployeeListError(e.toString()));
    }
  }

  Future<void> loadActiveEmployees() async {
    emit(EmployeeListLoading());
    try {
      final employees = await getActiveEmployees();
      final employeesDisplay =
          employees.map((e) => EmployeeDisplay.fromEmployee(e)).toList();
      emit(EmployeeListLoaded(employeesDisplay));
    } catch (e) {
      emit(EmployeeListError(e.toString()));
    }
  }

  Future<void> loadFormerEmployees() async {
    emit(EmployeeListLoading());
    try {
      final employees = await getFormerEmployees();
      final employeesDisplay =
          employees.map((e) => EmployeeDisplay.fromEmployee(e)).toList();
      emit(EmployeeListLoaded(employeesDisplay));
    } catch (e) {
      emit(EmployeeListError(e.toString()));
    }
  }

  Future<void> insertEmpl(Employee employee) async {
    try {
      await insertEmployee(employee);
      loadEmployees();
    } catch (e) {
      emit(EmployeeListError(e.toString()));
    }
  }

  Future<void> updateEmpl(Employee employee) async {
    try {
      await updateEmployee(employee);
      loadEmployees();
    } catch (e) {
      emit(EmployeeListError(e.toString()));
    }
  }

  Future<void> deleteEmpl(int id) async {
    try {
      await deleteEmployee(id);
      loadEmployees();
    } catch (e) {
      emit(EmployeeListError(e.toString()));
    }
  }
}
