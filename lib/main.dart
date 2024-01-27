import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'features/employee_list/presentation/cubit/employee_list_cubit.dart';
import 'injections/get_it_injections.dart';

void main() async {
  // Setup dependency injection
  setupDependencyInjection();

  runApp(
    BlocProvider(
      create: (_) => EmployeeListCubit(),
      child: const MyApp(),
    ),
  );
}
