import 'package:flutter/material.dart';
import 'package:ninja_coder_employee_demo/core/app_colors.dart';

import '../../../../core/app_text_styles.dart';

class EmpListItemHeader extends StatelessWidget {
  final String text;

  const EmpListItemHeader(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: AppColors.dividerColor,
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: AppTextStyles.stickyHeader,
      ),
    );
  }
}
