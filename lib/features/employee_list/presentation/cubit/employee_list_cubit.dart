import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/app_constacts.dart';
import '../../data/models/employee.dart';
import '../../domain/entities/employee_display.dart';
import '../../domain/usecases/crud_usecases.dart';

part 'employee_list_state.dart';

class EmployeeListCubit extends Cubit<EmployeeListState> {
  final GetEmployees getEmployees = GetIt.I<GetEmployees>();
  final GetActiveEmployees getActiveEmployees = GetIt.I<GetActiveEmployees>();
  final GetFormerEmployees getFormerEmployees = GetIt.I<GetFormerEmployees>();
  final InsertEmployee _insertEmployee = GetIt.I<InsertEmployee>();
  final UpdateEmployee _updateEmployee = GetIt.I<UpdateEmployee>();
  final DeleteEmployee _deleteEmployee = GetIt.I<DeleteEmployee>();

  EmployeeListCubit() : super(EmployeeListInitial());

  Future<void> loadEmployees() async {
    emit(EmployeeListLoading());
    try {
      final activeEmployees = await getActiveEmployees();
      final formerEmployees = await getFormerEmployees();
      final activeEmployeesDisplay =
          activeEmployees.map((e) => EmployeeDisplay.fromEmployee(e)).toList();
      final formerEmployeesDisplay =
          formerEmployees.map((e) => EmployeeDisplay.fromEmployee(e)).toList();
      emit(EmployeeListLoaded(activeEmployeesDisplay, formerEmployeesDisplay));
    } catch (e) {
      emit(EmployeeListError(e.toString()));
    }
  }

  // Future<void> loadActiveEmployees() async {
  //   emit(EmployeeListLoading());
  //   try {
  //     final employees = await getActiveEmployees();
  //     final employeesDisplay =
  //         employees.map((e) => EmployeeDisplay.fromEmployee(e)).toList();
  //     emit(EmployeeListLoaded(employeesDisplay));
  //   } catch (e) {
  //     emit(EmployeeListError(e.toString()));
  //   }
  // }

  // Future<void> loadFormerEmployees() async {
  //   emit(EmployeeListLoading());
  //   try {
  //     final employees = await getFormerEmployees();
  //     final employeesDisplay =
  //         employees.map((e) => EmployeeDisplay.fromEmployee(e)).toList();
  //     emit(EmployeeListLoaded(employeesDisplay));
  //   } catch (e) {
  //     emit(EmployeeListError(e.toString()));
  //   }
  // }

  // Future<void> insertEmpl(Employee employee) async {
  //   try {
  //     await insertEmployee(employee);
  //     loadEmployees();
  //   } catch (e) {
  //     emit(EmployeeListError(e.toString()));
  //   }
  // }

  Future<void> addEmployee(Employee newEmployee) async {
    int empId = await _insertEmployee(newEmployee);
    newEmployee.setId(empId);
    if (state is EmployeeListLoaded) {
      final currentState = state as EmployeeListLoaded;
      final newEmployeeDisplay = EmployeeDisplay.fromEmployee(newEmployee);
      List<EmployeeDisplay> updatedActiveEmployees =
          List<EmployeeDisplay>.from(currentState.activeEmployees);
      List<EmployeeDisplay> updatedFormerEmployees =
          List<EmployeeDisplay>.from(currentState.formerEmployees);
      if (newEmployee.leavingDate == null) {
        updatedActiveEmployees.add(newEmployeeDisplay);
      } else {
        updatedFormerEmployees.add(newEmployeeDisplay);
      }
      emit(EmployeeListLoaded(updatedActiveEmployees, updatedFormerEmployees));
    }
  }

  Future<void> updateEmpl(Employee employee) async {
    try {
      await _updateEmployee(employee);
      if (state is EmployeeListLoaded) {
        final currentState = state as EmployeeListLoaded;
        final updatedEmployeeDisplay = EmployeeDisplay.fromEmployee(employee);

        List<EmployeeDisplay> updatedActiveEmployees;
        List<EmployeeDisplay> updatedFormerEmployees;

        if (employee.leavingDate == null) {
          updatedActiveEmployees = currentState.activeEmployees.map((e) {
            return e.id == employee.id ? updatedEmployeeDisplay : e;
          }).toList();
          updatedFormerEmployees = currentState.formerEmployees;
        } else {
          updatedActiveEmployees = currentState.activeEmployees
              .where((e) => e.id != employee.id)
              .toList();
          updatedFormerEmployees = List.from(currentState.formerEmployees)
            ..add(updatedEmployeeDisplay);
        }

        emit(
            EmployeeListLoaded(updatedActiveEmployees, updatedFormerEmployees));
      }
    } catch (e) {
      emit(EmployeeListError(e.toString()));
    }
  }

  EmployeeDisplay? _lastDeletedEmployee;
  Future<void>? _deleteFuture;
  bool _shouldDelete = true;
  int _lastDeletedEmployeeIndex = -1;

  Future<void> deleteEmpl(int id) async {
    if (state is EmployeeListLoaded) {
      final currentState = state as EmployeeListLoaded;
      try {
        _lastDeletedEmployeeIndex =
            currentState.activeEmployees.indexWhere((e) => e.id == id);
        if (_lastDeletedEmployeeIndex == -1) {
          _lastDeletedEmployeeIndex =
              currentState.formerEmployees.indexWhere((e) => e.id == id);
          _lastDeletedEmployee =
              currentState.formerEmployees[_lastDeletedEmployeeIndex];
        } else {
          _lastDeletedEmployee =
              currentState.activeEmployees[_lastDeletedEmployeeIndex];
        }
      } catch (_) {
        _lastDeletedEmployee = null;
      }

      List<EmployeeDisplay> updatedActiveEmployees =
          currentState.activeEmployees.where((e) {
        return e.id != id;
      }).toList();
      List<EmployeeDisplay> updatedFormerEmployees =
          currentState.formerEmployees.where((e) {
        return e.id != id;
      }).toList();
      emit(EmployeeListLoaded(updatedActiveEmployees, updatedFormerEmployees));
      _shouldDelete = true;

      _deleteFuture = Future.delayed(
          const Duration(seconds: AppConstants.hideUndoOptionAfterSeconds + 1),
          () {
        if (_shouldDelete) {
          _deleteEmployee(id);
        }
      });
    }
  }

  Future<void> undoDelete() async {
    if (_lastDeletedEmployee != null) {
      _shouldDelete = false;
      addEmployeeToState(Employee.fromEmployeeDisplay(_lastDeletedEmployee!));
      _lastDeletedEmployee = null;
    }
  }

  void addEmployeeToState(Employee employee) {
    if (state is EmployeeListLoaded) {
      final currentState = state as EmployeeListLoaded;
      final newEmployeeDisplay = EmployeeDisplay.fromEmployee(employee);
      if (employee.leavingDate == null) {
        List<EmployeeDisplay> updatedActiveEmployees =
            List.from(currentState.activeEmployees);
        updatedActiveEmployees.insert(
            _lastDeletedEmployeeIndex, newEmployeeDisplay);
        emit(EmployeeListLoaded(
            updatedActiveEmployees, currentState.formerEmployees));
      } else {
        List<EmployeeDisplay> updatedFormerEmployees =
            List.from(currentState.formerEmployees);
        updatedFormerEmployees.insert(
            _lastDeletedEmployeeIndex, newEmployeeDisplay);
        emit(EmployeeListLoaded(
            currentState.activeEmployees, updatedFormerEmployees));
      }
    }
  }
}
