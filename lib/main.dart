import 'package:flutter/material.dart';

import 'app.dart';
import 'injections/get_it_injections.dart';

void main() async {
  // Setup dependency injection
  setupDependencyInjection();

  runApp(const MyApp());
}
