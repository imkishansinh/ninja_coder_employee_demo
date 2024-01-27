import 'package:get_it/get_it.dart';

import '../features/employee_list/data/datasources/employee_datasource.dart';
import '../features/employee_list/domain/usecases/crud_usecases.dart';

void setupDependencyInjection() {
  // Datasource
  GetIt.I.registerSingleton<EmployeeDatasource>(EmployeeDatasource());

  // Register use cases
  GetIt.I.registerLazySingleton(() => InsertEmployee());
  GetIt.I.registerLazySingleton(() => GetEmployees());
  GetIt.I.registerLazySingleton(() => UpdateEmployee());
  GetIt.I.registerLazySingleton(() => DeleteEmployee());
  GetIt.I.registerLazySingleton(() => GetActiveEmployees());
  GetIt.I.registerLazySingleton(() => GetFormerEmployees());
}
