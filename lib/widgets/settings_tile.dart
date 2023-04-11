import 'package:flutter/material.dart';

class SettingsActionTile extends StatelessWidget {
  Function() onTap;
  String title;
  String subTitle;
  Icon icon;
  Color colorr;
  SettingsActionTile({
    Key? key,
    required this.onTap,
    required this.title,
    required this.subTitle,
    required this.icon,
    this.colorr = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          color: colorr,
          fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subTitle
      ),
      horizontalTitleGap: 0,
    );
  }
}