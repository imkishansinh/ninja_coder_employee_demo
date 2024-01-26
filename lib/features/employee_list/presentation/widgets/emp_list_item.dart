import 'package:flutter/material.dart';
import 'package:ninja_coder_employee_demo/core/app_text_styles.dart';

class EmpListItem extends StatelessWidget {
  final String itemKey;
  final String title;
  final String subTitle;
  final String desc;
  final Function(String) onDismissed;

  const EmpListItem({
    super.key,
    required this.title,
    required this.subTitle,
    required this.desc,
    required this.itemKey,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(itemKey),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDismissed(itemKey);
      },
      child: Container(
        width: double.maxFinite,
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTextStyles.listTileTitle,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              subTitle,
              style: AppTextStyles.listTileSubTitle,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              desc,
              style: AppTextStyles.listTileSubDesc,
            ),
          ],
        ),
      ),
    );
  }
}
