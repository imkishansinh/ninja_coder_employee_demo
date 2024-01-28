import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ninja_coder_employee_demo/core/app_colors.dart';
import 'package:ninja_coder_employee_demo/features/employee_list/presentation/pages/add_update_employee_details_page.dart';

import 'features/employee_list/presentation/pages/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        AddUpdateEmpDetailsParent.routeName: (context) =>
            const AddUpdateEmpDetailsParent(),
      },
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primaryColor,
          onPrimary: AppColors.onPrimaryColor,
          secondary: AppColors.secondaryColor,
          onSecondary: AppColors.onSecondaryColor,
          error: AppColors.errorColor,
          onError: AppColors.onErrorColor,
          background: AppColors.backgroundColor,
          onBackground: AppColors.onBackgroundColor,
          surface: AppColors.surfaceColor,
          onSurface: AppColors.onSurfaceColor,
        ),
        fontFamily: GoogleFonts.roboto().fontFamily,
      ),
    );
  }
}
