import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'employee_list_state.dart';

class EmployeeListCubit extends Cubit<EmployeeListState> {
  EmployeeListCubit() : super(EmployeeListInitial());
}
