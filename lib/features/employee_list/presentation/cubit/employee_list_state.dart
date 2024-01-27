part of 'employee_list_cubit.dart';

abstract class EmployeeListState extends Equatable {
  const EmployeeListState();

  @override
  List<Object> get props => [];
}

class EmployeeListInitial extends EmployeeListState {}

class EmployeeListLoading extends EmployeeListState {}

class EmployeeListLoaded extends EmployeeListState {
  final List<EmployeeDisplay> employees;

  const EmployeeListLoaded(this.employees);

  @override
  List<Object> get props => [employees];
}

class EmployeeListError extends EmployeeListState {
  final String message;

  const EmployeeListError(this.message);

  @override
  List<Object> get props => [message];
}
