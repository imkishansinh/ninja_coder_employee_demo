import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isEnabled;
  final String hintText;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final TextInputType? textInputType;
  final String? regex;
  final Widget prefixIcon;
  final Widget? suffixIcon;

  const AppTextField({
    required this.controller,
    required this.hintText,
    this.isEnabled = true,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    this.textInputType,
    this.regex,
    this.suffixIcon,
    required this.prefixIcon,
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: isEnabled,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      textCapitalization: textCapitalization,
      inputFormatters: regex != null
          ? [
              FilteringTextInputFormatter.allow(
                RegExp(regex!),
              ),
            ]
          : null,
      style: AppTextStyles.textField,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
        hintText: hintText,
        hintStyle: AppTextStyles.textField.copyWith(
          color: AppColors.textFieldHintColor,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: AppColors.textFieldBorderColor,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: AppColors.textFieldBorderColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: AppColors.textFieldBorderColor,
            width: 1,
          ),
        ),
      ),
    );
  }
}
