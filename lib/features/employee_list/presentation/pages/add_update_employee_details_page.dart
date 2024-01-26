import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ninja_coder_employee_demo/core/app_assets.dart';
import 'package:ninja_coder_employee_demo/core/app_text_styles.dart';
import 'package:ninja_coder_employee_demo/features/employee_list/presentation/widgets/app_text_field.dart';

import 'package:table_calendar/table_calendar.dart';

import '../../../../core/app_colors.dart';

class AddUpdateEmpDetailsPage extends StatelessWidget {
  static var routeName = '/addUpdateEmpDetailsPage';

  const AddUpdateEmpDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> roles = [
      'Product Designer',
      'Flutter Developer',
      'QA Tester',
      'Product Owner',
    ];
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
        title: const Text(
          'Edit Employee Details',
          style: AppTextStyles.appBarTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {},
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
                        Navigator.of(context).pop();
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
                      onPressed: () {},
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
                      controller: TextEditingController(),
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
                    onTap: () {
                      showModalBottomSheet(
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
                                itemCount: roles.length,
                                itemBuilder: (_, int index) {
                                  return ListTile(
                                    title: Text(
                                      roles[index],
                                      textAlign: TextAlign.center,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
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
                    },
                    child: SizedBox(
                      height: 40,
                      child: AppTextField(
                        controller: TextEditingController(),
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
                              showCalendarPopup(context);
                            },
                            child: AppTextField(
                              controller: TextEditingController(text: 'Today'),
                              hintText: 'Today',
                              prefixIcon: Image.asset(AppAssets.eventIcon),
                              isEnabled: false,
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
                          child: AppTextField(
                            controller: TextEditingController(),
                            hintText: 'No date',
                            prefixIcon: Image.asset(AppAssets.eventIcon),
                            isEnabled: false,
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

  void showCalendarPopup(BuildContext context) {
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // To make the dialog as big as its children
                  children: [
                    Column(
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
                                      foregroundColor: AppColors.onPrimaryColor,
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
                    TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      // lastDay: DateTime
                      //     .now(), // Set the last day to the current date
                      lastDay: DateTime.utc(2030, 10, 16),
                      focusedDay: selectedDate,
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: AppTextStyles.calendarTitle,
                        leftChevronIcon:
                            Image.asset(AppAssets.previousMonthIcon),
                        rightChevronIcon: Image.asset(AppAssets.nextMonthIcon),
                      ),
                      onDaySelected: (selectedDay, focusedDay) {
                        if (selectedDay.isAfter(DateTime.now())) {
                          // Do not allow the selection of a future date
                          return;
                        }
                        setState(() {
                          selectedDate = selectedDay;
                        });
                      },
                    ),
                    const Divider(
                      thickness: 1,
                      color: AppColors.dividerColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(AppAssets.eventIcon),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          DateFormat('dd MMM yyyy').format(selectedDate),
                          style: AppTextStyles.selectedDateTextStyle,
                        ),
                        Expanded(
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
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: AppColors.onPrimaryColor,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Save',
                            ),
                          ),
                        )
                      ],
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
}
