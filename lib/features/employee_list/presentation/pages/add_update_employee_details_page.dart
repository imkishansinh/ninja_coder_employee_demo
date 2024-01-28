import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ninja_coder_employee_demo/core/app_assets.dart';
import 'package:ninja_coder_employee_demo/core/app_text_styles.dart';
import 'package:ninja_coder_employee_demo/features/employee_list/data/models/employee.dart';
import 'package:ninja_coder_employee_demo/features/employee_list/domain/entities/employee_display.dart';
import 'package:ninja_coder_employee_demo/features/employee_list/presentation/cubit/employee_list_cubit.dart';
import 'package:ninja_coder_employee_demo/features/employee_list/presentation/widgets/app_text_field.dart';

import 'package:table_calendar/table_calendar.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_constacts.dart';

enum PageOperation { add, update }

class AddUpdatePageArguments {
  final PageOperation pageOperation;
  final EmployeeDisplay? employee;

  AddUpdatePageArguments({
    required this.pageOperation,
    this.employee,
  });
}

class AddUpdateEmpDetailsParent extends StatelessWidget {
  static var routeName = '/addUpdateEmpDetailsPage';
  const AddUpdateEmpDetailsParent({super.key});

  @override
  Widget build(BuildContext context) {
    final AddUpdatePageArguments args =
        ModalRoute.of(context)!.settings.arguments as AddUpdatePageArguments;
    return AddUpdateEmpDetailsPage(args);
  }
}

class AddUpdateEmpDetailsPage extends StatelessWidget {
  final AddUpdatePageArguments args;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _joiningDateController =
      TextEditingController(text: 'Today');
  final TextEditingController _leavingDateController = TextEditingController();
  DateTime joiningDate = DateTime.now();
  DateTime leavingDate = DateTime.now();

  AddUpdateEmpDetailsPage(this.args, {super.key});

  @override
  Widget build(BuildContext context) {
    if (args.pageOperation == PageOperation.update) {
      _nameController.text = args.employee!.name;
      _roleController.text = args.employee!.role;
      _joiningDateController.text = args.employee!.joiningDate;
      joiningDate = DateFormat("dd MMM yyyy").parse(args.employee!.joiningDate);
      if (args.employee!.leavingDate != null) {
        _leavingDateController.text = args.employee!.leavingDate!;
        leavingDate =
            DateFormat("dd MMM yyyy").parse(args.employee!.leavingDate!);
      }
    }
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
        title: Text(
          args.pageOperation == PageOperation.add
              ? 'Add Employee Details'
              : 'Edit Employee Details',
          style: AppTextStyles.appBarTextStyle,
        ),
        actions: [
          if (args.pageOperation == PageOperation.update)
            IconButton(
              onPressed: () {
                BlocProvider.of<EmployeeListCubit>(context)
                    .deleteEmpl(args.employee!.id)
                    .then((value) {
                  Navigator.of(context).pop();
                });
              },
              icon: Image.asset(AppAssets.deleteIcon),
            ),
        ],
      ),
      bottomNavigationBar: Builder(builder: (context) {
        final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

        return Container(
          color: AppColors.backgroundColor,
          padding: EdgeInsets.only(
            bottom: keyboardPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(
                height: 1,
                thickness: 2,
                color: AppColors.dividerColor,
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                        foregroundColor: AppColors.onSecondaryColor,
                      ),
                      onPressed: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (MediaQuery.of(context).viewInsets.bottom != 0) {
                          currentFocus.unfocus();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text(
                        'Cancel',
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        _saveEmployeeDetails(context);
                      },
                      child: const Text(
                        'Save',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      }),
      body: GestureDetector(
        // Hide k/b when user taps outside of form
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // Form started here
          child: Form(
            key: _formKey,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  // Employee name
                  SizedBox(
                    height: 40,
                    child: AppTextField(
                      controller: _nameController,
                      hintText: 'Employee name',
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      textInputType: TextInputType.name,
                      regex: r'[a-zA-Z\s]',
                      prefixIcon: Image.asset(AppAssets.personIcon),
                    ),
                  ),
                  const SizedBox(height: 23),
                  // Employee role
                  GestureDetector(
                    onTap: () async {
                      String role = await showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return Wrap(
                            children: <Widget>[
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: AppConstants.roles.length,
                                itemBuilder: (_, int index) {
                                  return ListTile(
                                    title: Text(
                                      AppConstants.roles[index],
                                      textAlign: TextAlign.center,
                                    ),
                                    onTap: () {
                                      Navigator.of(context)
                                          .pop(AppConstants.roles[index]);
                                    },
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider(
                                    color: AppColors.dividerColor,
                                    thickness: 2,
                                    height: 1,
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );

                      _roleController.text = role;
                    },
                    child: SizedBox(
                      height: 40,
                      child: AppTextField(
                        controller: _roleController,
                        hintText: 'Select role',
                        isEnabled: false,
                        prefixIcon: Image.asset(AppAssets.workIcon),
                        suffixIcon: Image.asset(AppAssets.arrowDropDownIcon),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  // Employee Joining and Leaving date
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: GestureDetector(
                            onTap: () {
                              selectJoiningDate(context);
                            },
                            child: AppTextField(
                              controller: _joiningDateController,
                              hintText: 'Today',
                              prefixIcon: Image.asset(AppAssets.eventIcon),
                              isEnabled: false,
                              textStyle: AppTextStyles.textField
                                  .copyWith(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Image.asset(AppAssets.arrowRight),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: GestureDetector(
                            onTap: () {
                              selectLeavingDate(context);
                            },
                            child: AppTextField(
                              controller: _leavingDateController,
                              hintText: 'No date',
                              prefixIcon: Image.asset(AppAssets.eventIcon),
                              isEnabled: false,
                              textStyle: AppTextStyles.textField
                                  .copyWith(fontSize: 14),
                              hintStyle: AppTextStyles.textField.copyWith(
                                color: AppColors.textFieldHintColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Define a function to show the calendar popup
  void selectJoiningDate(BuildContext context) {
    DateTime selectedDate = args.pageOperation == PageOperation.update
        ? joiningDate
        : DateTime.now();
    DateTime focusedDate = args.pageOperation == PageOperation.update
        ? joiningDate
        : DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 16),
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // To make the dialog as big as its children
                  children: [
                    // Custom 4 actions
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 36,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 36,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .secondaryHeaderColor,
                                        foregroundColor:
                                            AppColors.onSecondaryColor,
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          height: 20 / 14,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          selectedDate = DateTime.now();
                                        });
                                      },
                                      child: const Text(
                                        'Today',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: SizedBox(
                                    height: 36,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        foregroundColor:
                                            AppColors.onPrimaryColor,
                                      ),
                                      onPressed: () {
                                        DateTime nextMonday = getNextMonday();
                                        // if (nextMonday.isAfter(DateTime.now())) {
                                        setState(() {
                                          selectedDate = nextMonday;
                                        });
                                        // }
                                      },
                                      child: const Text(
                                        'Next Monday',
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 36,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 36,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .secondaryHeaderColor,
                                        foregroundColor:
                                            AppColors.onSecondaryColor,
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          height: 20 / 14,
                                        ),
                                      ),
                                      onPressed: () {
                                        DateTime nextTuesday = getNextTuesday();
                                        setState(() {
                                          selectedDate = nextTuesday;
                                        });
                                      },
                                      child: const Text(
                                        'Next Tuesday',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: SizedBox(
                                    height: 36,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .secondaryHeaderColor,
                                        foregroundColor:
                                            AppColors.onSecondaryColor,
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          height: 20 / 14,
                                        ),
                                      ),
                                      onPressed: () {
                                        DateTime nextWeek = getNextWeek();
                                        setState(() {
                                          selectedDate = nextWeek;
                                        });
                                      },
                                      child: const Text(
                                        'After 1 week',
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // Main calendar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TableCalendar(
                        selectedDayPredicate: (day) {
                          // Compare the selected day with the current day
                          return isSameDay(selectedDate, day);
                        },
                        calendarBuilders: CalendarBuilders(
                          // To hide previous and next month dates
                          outsideBuilder: (context, date, _) =>
                              const SizedBox.shrink(),
                          // Today date style
                          todayBuilder: (context, date, _) => Container(
                            margin: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(
                                BorderSide(
                                  color: Colors.blue,
                                  width: 1,
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              date.day.toString(),
                              style: AppTextStyles.calendarDateText.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          // Selected date style
                          selectedBuilder: (context, date, _) => Container(
                            margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              date.day.toString(),
                              style: AppTextStyles.calendarDateText.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        firstDay: DateTime.utc(2010, 10, 16),
                        // lastDay: DateTime
                        //     .now(), // Set the last day to the current date
                        lastDay: DateTime.utc(2030, 10, 16),
                        focusedDay: focusedDate,
                        // Left right chevron icons with current month name
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: AppTextStyles.calendarTitle,
                          leftChevronIcon:
                              Image.asset(AppAssets.previousMonthIcon),
                          rightChevronIcon:
                              Image.asset(AppAssets.nextMonthIcon),
                          leftChevronMargin: const EdgeInsets.only(left: 32),
                          rightChevronMargin: const EdgeInsets.only(right: 32),
                        ),
                        onDaySelected: (selectedDay, focusedDay) {
                          // if (selectedDay.isAfter(DateTime.now())) {
                          //   // Do not allow the selection of a future date
                          //   return;
                          // }
                          setState(() {
                            selectedDate = selectedDay;
                            focusedDate = focusedDay;
                          });
                        },
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      color: AppColors.dividerColor,
                    ),
                    // cancel and save buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(AppAssets.eventIcon),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('dd MMM yyyy').format(selectedDate),
                            style: AppTextStyles.selectedDateTextStyle,
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 73,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).secondaryHeaderColor,
                                foregroundColor: AppColors.onSecondaryColor,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 20 / 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 73,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: AppColors.onPrimaryColor,
                              ),
                              onPressed: () {
                                _joiningDateController.text =
                                    DateFormat('dd MMM yyyy')
                                        .format(selectedDate);
                                joiningDate = selectedDate;
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 20 / 14,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Define a function to show the calendar popup
  void selectLeavingDate(BuildContext context) {
    DateTime selectedDate = args.pageOperation == PageOperation.update
        ? leavingDate
        : DateTime.now();
    DateTime focusedDate = args.pageOperation == PageOperation.update
        ? leavingDate
        : DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 16),
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // To make the dialog as big as its children
                  children: [
                    // Custom 4 actions
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 36,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 36,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        foregroundColor:
                                            AppColors.onPrimaryColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _leavingDateController.text =
                                              'No date';
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: const Text(
                                        'No date',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: SizedBox(
                                    height: 36,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .secondaryHeaderColor,
                                        foregroundColor:
                                            AppColors.onSecondaryColor,
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          height: 20 / 14,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          selectedDate = DateTime.now();
                                          _leavingDateController.text =
                                              DateFormat('dd MMM yyyy')
                                                  .format(selectedDate);
                                        });
                                      },
                                      child: const Text(
                                        'Today',
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Main calendar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TableCalendar(
                        selectedDayPredicate: (day) {
                          // Compare the selected day with the current day
                          return isSameDay(selectedDate, day);
                        },
                        calendarBuilders: CalendarBuilders(
                          // To hide previous and next month dates
                          outsideBuilder: (context, date, _) =>
                              const SizedBox.shrink(),
                          // Today date style
                          todayBuilder: (context, date, _) => Container(
                            margin: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(
                                BorderSide(
                                  color: Colors.blue,
                                  width: 1,
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              date.day.toString(),
                              style: AppTextStyles.calendarDateText.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          // Selected date style
                          selectedBuilder: (context, date, _) => Container(
                            margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              date.day.toString(),
                              style: AppTextStyles.calendarDateText.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        firstDay: DateTime.utc(2010, 10, 16),
                        // lastDay: DateTime
                        //     .now(), // Set the last day to the current date
                        lastDay: DateTime.utc(2030, 10, 16),
                        focusedDay: focusedDate,
                        // Left right chevron icons with current month name
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: AppTextStyles.calendarTitle,
                          leftChevronIcon:
                              Image.asset(AppAssets.previousMonthIcon),
                          rightChevronIcon:
                              Image.asset(AppAssets.nextMonthIcon),
                          leftChevronMargin: const EdgeInsets.only(left: 32),
                          rightChevronMargin: const EdgeInsets.only(right: 32),
                        ),
                        onDaySelected: (selectedDay, focusedDay) {
                          // if (selectedDay.isAfter(DateTime.now())) {
                          //   // Do not allow the selection of a future date
                          //   return;
                          // }
                          setState(() {
                            selectedDate = selectedDay;
                            focusedDate = focusedDay; // Add this line
                          });
                        },
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      color: AppColors.dividerColor,
                    ),
                    // cancel and save buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(AppAssets.eventIcon),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('dd MMM yyyy').format(selectedDate),
                            style: AppTextStyles.selectedDateTextStyle,
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 73,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).secondaryHeaderColor,
                                foregroundColor: AppColors.onSecondaryColor,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 20 / 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 73,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: AppColors.onPrimaryColor,
                              ),
                              onPressed: () {
                                _leavingDateController.text =
                                    DateFormat('dd MMM yyyy')
                                        .format(selectedDate);
                                leavingDate = selectedDate;
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 20 / 14,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Define a function to get the next Monday
  DateTime getNextMonday() {
    DateTime now = DateTime.now();
    return now.add(Duration(
        days: (DateTime.daysPerWeek - now.weekday + 1) % DateTime.daysPerWeek));
  }

  // Define a function to get the next Tuesday
  DateTime getNextTuesday() {
    DateTime now = DateTime.now();
    return now.add(Duration(
        days: (DateTime.daysPerWeek - now.weekday + 2) % DateTime.daysPerWeek));
  }

  // Define a function to get the date one week from now
  DateTime getNextWeek() {
    DateTime now = DateTime.now();
    return now.add(const Duration(days: 7));
  }

  // Define a function to save the employee details
  void _saveEmployeeDetails(BuildContext context) {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter employee name'),
        ),
      );
      return;
    } else if (_roleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select emplyee role'),
        ),
      );
      return;
    } else {
      Employee employee = Employee(
        id: 0,
        name: _nameController.text.toString().trim(),
        role: _roleController.text.toString(),
        joiningDate: _joiningDateController.text.toString().toLowerCase() ==
                'Today'.toLowerCase()
            ? DateTime.now()
            : joiningDate,
        leavingDate: _leavingDateController.text.isEmpty ||
                _leavingDateController.text.toString().toLowerCase() ==
                    'No date'.toLowerCase()
            ? null
            : leavingDate,
      );

      if (args.pageOperation == PageOperation.update) {
        employee.id = args.employee!.id;
        BlocProvider.of<EmployeeListCubit>(context)
            .updateEmpl(employee)
            .then((value) {
          Navigator.of(context).pop();
        });
      } else {
        BlocProvider.of<EmployeeListCubit>(context)
            .addEmployee(employee)
            .then((value) {
          Navigator.of(context).pop();
        });
      }
    }
  }
}
