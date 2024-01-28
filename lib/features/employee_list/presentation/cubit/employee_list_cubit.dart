import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/app_constacts.dart';
import '../../data/models/employee.dart';
import '../../domain/entities/employee_display.dart';
import '../../domain/usecases/crud_usecases.dart';

part 'employee_list_state.dart';

class EmployeeListCubit extends Cubit<EmployeeListState> {
  // use cases
  final GetEmployees getEmployees = GetIt.I<GetEmployees>();
  final GetActiveEmployees getActiveEmployees = GetIt.I<GetActiveEmployees>();
  final GetFormerEmployees getFormerEmployees = GetIt.I<GetFormerEmployees>();
  final InsertEmployee _insertEmployee = GetIt.I<InsertEmployee>();
  final UpdateEmployee _updateEmployee = GetIt.I<UpdateEmployee>();
  final DeleteEmployee _deleteEmployee = GetIt.I<DeleteEmployee>();

  EmployeeListCubit() : super(EmployeeListInitial());

  /// Loads the list of employees asynchronously.
  /// Emits [EmployeeListLoading] state before loading the employees.
  /// If the loading is successful, emits [EmployeeListLoaded] state with the active and former employees.
  /// If an error occurs during loading, emits [EmployeeListError] state with the error message.
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

  /// Adds a new employee to the employee list.
  ///
  /// The [newEmployee] parameter represents the employee to be added.
  /// This method inserts the employee into the database and updates the state of the employee list.
  /// If the employee's leaving date is null, the employee is added to the active employees list.
  /// Otherwise, the employee is added to the former employees list.
  ///
  /// Throws an exception if there is an error inserting the employee into the database.
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

  /// Updates the given [employee].
  ///
  /// The method first calls the private method `_updateEmployee` to perform the actual update operation.
  /// If the state of the cubit is [EmployeeListLoaded], it updates the lists of active and former employees
  /// based on the updated employee's leaving date. If the employee's leaving date is null, it updates the
  /// active employees list, otherwise it updates the former employees list. The updated lists are then used
  /// to emit a new [EmployeeListLoaded] state.
  ///
  /// If an error occurs during the update, the cubit emits an [EmployeeListError] state with the error message.
  Future<void> updateEmpl(Employee employee) async {
    try {
      await _updateEmployee(employee);
      if (state is EmployeeListLoaded) {
        final currentState = state as EmployeeListLoaded;
        final updatedEmployeeDisplay = EmployeeDisplay.fromEmployee(employee);

        List<EmployeeDisplay> updatedActiveEmployees;
        List<EmployeeDisplay> updatedFormerEmployees;

        if (employee.leavingDate == null) {
          updatedFormerEmployees = currentState.formerEmployees
              .where((e) => e.id != employee.id)
              .toList();
          if (!currentState.activeEmployees.any((e) => e.id == employee.id)) {
            updatedActiveEmployees = List.from(currentState.activeEmployees)
              ..add(updatedEmployeeDisplay);
          } else {
            updatedActiveEmployees = currentState.activeEmployees.map((e) {
              return e.id == employee.id ? updatedEmployeeDisplay : e;
            }).toList();
          }
        } else {
          updatedActiveEmployees = currentState.activeEmployees
              .where((e) => e.id != employee.id)
              .toList();
          if (!currentState.formerEmployees.any((e) => e.id == employee.id)) {
            updatedFormerEmployees = List.from(currentState.formerEmployees)
              ..add(updatedEmployeeDisplay);
          } else {
            updatedFormerEmployees = currentState.formerEmployees.map((e) {
              return e.id == employee.id ? updatedEmployeeDisplay : e;
            }).toList();
          }
        }

        emit(
            EmployeeListLoaded(updatedActiveEmployees, updatedFormerEmployees));
      }
    } catch (e) {
      emit(EmployeeListError(e.toString()));
    }
  }

  // The following fields are used to implement the undo delete feature.
  EmployeeDisplay? _lastDeletedEmployee;
  Future<void>? _deleteFuture;
  bool _shouldDelete = true;
  int _lastDeletedEmployeeIndex = -1;

  /// Deletes an employee with the specified [id].
  /// If the employee is found in the active employees list, it is removed from there.
  /// If the employee is not found in the active employees list, it is searched in the former employees list and removed from there.
  /// After deleting the employee, the updated active employees and former employees lists are emitted.
  /// If the delete operation is not canceled within a certain duration, the employee is permanently deleted.
  ///
  /// Parameters:
  /// - [id]: The id of the employee to delete.
  ///
  /// Throws:
  /// - [Exception]: If an error occurs while deleting the employee.
  ///
  /// Returns:
  /// - [void]
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

  /// Undoes the delete operation by adding the last deleted employee back to the state.
  /// If there is no last deleted employee, this method does nothing.
  /// Sets the [_shouldDelete] flag to false.
  Future<void> undoDelete() async {
    if (_lastDeletedEmployee != null) {
      _shouldDelete = false;
      addEmployeeToState(Employee.fromEmployeeDisplay(_lastDeletedEmployee!));
      _lastDeletedEmployee = null;
    }
  }

  /// Adds an [Employee] to the current state of the employee list.
  ///
  /// If the current state is [EmployeeListLoaded], the method inserts the new employee
  /// into the appropriate list based on their leaving date. If the leaving date is null,
  /// the employee is added to the list of active employees. Otherwise, the employee is
  /// added to the list of former employees.
  ///
  /// The [employee] parameter represents the employee to be added to the state.
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
