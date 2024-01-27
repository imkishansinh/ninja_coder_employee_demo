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
    List<Map<String, dynamic>> currentEmployees = [
      // {
      //   'id': 1,
      //   'name': 'John Doe',
      //   'role': 'Software Developer',
      //   'joiningDate': DateTime(2020, 1, 1),
      //   'leavingDate': null, // still employed
      // },
      // {
      //   'id': 2,
      //   'name': 'Jane Smith',
      //   'role': 'Product Manager',
      //   'joiningDate': DateTime(2019, 5, 20),
      //   'leavingDate': null, // still employed
      // },
      // {
      //   'id': 3,
      //   'name': 'Bob Johnson',
      //   'role': 'UX Designer',
      //   'joiningDate': DateTime(2021, 2, 15),
      //   'leavingDate': null, // still employed
      // },
    ];

    List<Map<String, dynamic>> previousEmployees = [
      // {
      //   'id': 4,
      //   'name': 'Alice Williams',
      //   'role': 'Data Analyst',
      //   'joiningDate': DateTime(2018, 7, 30),
      //   'leavingDate': DateTime(2020, 12, 31),
      // },
      // {
      //   'id': 5,
      //   'name': 'Charlie Brown',
      //   'role': 'Software Tester',
      //   'joiningDate': DateTime(2017, 3, 15),
      //   'leavingDate': DateTime(2021, 1, 1),
      // },
    ];

    int itemCount = currentEmployees.length +
        previousEmployees.length +
        (currentEmployees.isEmpty ? 0 : 1) +
        (previousEmployees.isEmpty ? 0 : 1); // Add 1 for each non-empty list

    return Scaffold(
      backgroundColor: AppColors.dividerColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Employee List',
          style: AppTextStyles.appBarTextStyle,
        ),
      ),
      floatingActionButton: SizedBox(
        width: 50,
        height: 50,
        child: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.onPrimaryColor,
          onPressed: () {
            Navigator.of(context).pushNamed(
              AddUpdateEmpDetailsPage.routeName,
            );
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: const Icon(
            Icons.add_rounded,
            size: 18,
          ),
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
                  child: ListView.separated(
                    itemCount: itemCount,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.dividerColor,
                    ),
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

  Widget buildEmployeeItem(Map<String, dynamic> previousEmploye) {
    return EmpListItem(
      title: previousEmploye['name'],
      subTitle: previousEmploye['role'],
      desc: 'desc',
      itemKey: '${previousEmploye['id']}',
      onDismissed: (p0) {},
    );
  }
}
