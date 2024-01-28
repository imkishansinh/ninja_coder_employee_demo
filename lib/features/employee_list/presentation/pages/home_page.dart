import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ninja_coder_employee_demo/core/app_assets.dart';
import 'package:ninja_coder_employee_demo/core/app_colors.dart';
import 'package:ninja_coder_employee_demo/core/app_constacts.dart';
import 'package:ninja_coder_employee_demo/core/app_text_styles.dart';
import 'package:ninja_coder_employee_demo/features/employee_list/domain/entities/employee_display.dart';
import 'package:ninja_coder_employee_demo/features/employee_list/presentation/pages/add_update_employee_details_page.dart';

import '../cubit/employee_list_cubit.dart';
import '../widgets/emp_list_item.dart';
import '../widgets/emp_list_item_header.dart';

class HomePage extends StatelessWidget {
  static var routeName = '/';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<EmployeeListCubit>(context).loadEmployees();

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
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.onPrimaryColor,
          onPressed: () {
            Navigator.of(context).pushNamed(
              AddUpdateEmpDetailsParent.routeName,
              arguments:
                  AddUpdatePageArguments(pageOperation: PageOperation.add),
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
      body: BlocBuilder<EmployeeListCubit, EmployeeListState>(
        bloc: BlocProvider.of<EmployeeListCubit>(context),
        builder: (context, state) {
          if (state is EmployeeListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeListLoaded) {
            final currentEmployees = state.activeEmployees;
            final previousEmployees = state.formerEmployees;
            if (currentEmployees.isEmpty && previousEmployees.isEmpty) {
              return Center(child: Image.asset(AppAssets.noEmpState));
            }

            int itemCount = currentEmployees.length +
                previousEmployees.length +
                (currentEmployees.isEmpty ? 0 : 1) +
                (previousEmployees.isEmpty ? 0 : 1);
            return Stack(
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
                        return buildEmployeeItem(
                            currentEmployees[index - 1], context);
                      } else if (index ==
                              currentEmployees.length +
                                  (currentEmployees.isNotEmpty ? 1 : 0) &&
                          previousEmployees.isNotEmpty) {
                        return const EmpListItemHeader('Previously Employees');
                      } else {
                        return buildEmployeeItem(
                            previousEmployees[index -
                                currentEmployees.length -
                                (currentEmployees.isNotEmpty ? 1 : 0) -
                                (previousEmployees.isNotEmpty ? 1 : 0)],
                            context);
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
            );
          } else if (state is EmployeeListError) {
            return Text('Error: ${state.message}');
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildEmployeeItem(EmployeeDisplay employee, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AddUpdateEmpDetailsParent.routeName,
          arguments: AddUpdatePageArguments(
            pageOperation: PageOperation.update,
            employee: employee,
          ),
        );
      },
      child: EmpListItem(
        title: employee.name,
        subTitle: employee.role,
        desc:
            '${employee.leavingDate == null ? 'From ${employee.joiningDate}' : employee.joiningDate} ${employee.leavingDate == null ? '' : ' - ${employee.leavingDate}'}',
        itemKey: '${employee.id}',
        onDismissed: (p0) {
          final employeeListCubit = BlocProvider.of<EmployeeListCubit>(context);
          employeeListCubit.deleteEmpl(employee.id);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Employee data has been deleted'),
              duration: const Duration(
                  seconds: AppConstants.hideUndoOptionAfterSeconds),
              action: SnackBarAction(
                label: 'UNDO',
                textColor: AppColors.primaryColor,
                onPressed: () {
                  employeeListCubit.undoDelete();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
