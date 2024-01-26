import 'package:flutter/material.dart';
import 'package:ninja_coder_employee_demo/core/app_assets.dart';
import 'package:ninja_coder_employee_demo/core/app_colors.dart';
import 'package:ninja_coder_employee_demo/core/app_text_styles.dart';
import 'package:ninja_coder_employee_demo/features/employee_list/presentation/pages/add_update_employee_details_page.dart';

import '../widgets/emp_list_item.dart';
import '../widgets/emp_list_item_header.dart';

class HomePage extends StatelessWidget {
  static var routeName = '/';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List currentEmployees = [1, 1, 1];
    List previousEmployees = [];

    int itemCount = currentEmployees.length +
        previousEmployees.length +
        (currentEmployees.isEmpty ? 0 : 1) +
        (previousEmployees.isEmpty ? 0 : 1); // Add 1 for each non-empty list

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Employee List',
          style: AppTextStyles.appBarTextStyle,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.onPrimaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed(
            AddUpdateEmpDetailsPage.routeName,
          );
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('You tapped on plus icon'),
          //   ),
          // );
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: const Icon(
          Icons.add,
        ),
      ),
      body: currentEmployees.isEmpty && previousEmployees.isEmpty
          ? Center(
              child: Image.asset(AppAssets.noEmpState),
            )
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: ListView.builder(
                    itemCount: itemCount,
                    itemBuilder: (_, index) {
                      if (index == 0 && currentEmployees.isNotEmpty) {
                        return const EmpListItemHeader('Current Employees');
                      } else if (index <= currentEmployees.length &&
                          currentEmployees.isNotEmpty) {
                        return buildEmployeeItem(currentEmployees[index - 1]);
                      } else if (index ==
                              currentEmployees.length +
                                  (currentEmployees.isNotEmpty ? 1 : 0) &&
                          previousEmployees.isNotEmpty) {
                        return const EmpListItemHeader('Previously Employees');
                      } else {
                        return buildEmployeeItem(previousEmployees[index -
                            currentEmployees.length -
                            (currentEmployees.isNotEmpty ? 1 : 0) -
                            (previousEmployees.isNotEmpty ? 1 : 0)]);
                      }
                    },
                  ),
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.maxFinite,
                      color: AppColors.dividerColor,
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Swipe left to delete',
                        style: AppTextStyles.stickyHeader.copyWith(
                          color: AppColors.listTileDescColor,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Widget buildEmployeeItem(int previousEmploye) {
    return EmpListItem(
      title: 'title',
      subTitle: 'subTitle',
      desc: 'desc',
      itemKey: '$previousEmploye',
      onDismissed: (p0) {},
    );
  }
}
