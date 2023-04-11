import 'package:flutter/material.dart';

class FollowEditButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;
  final Color borderColor;
  final String title;
  final Color titleColor;
  const FollowEditButton({
    Key? key,
    this.function,
    required this.backgroundColor,
    required this.borderColor,
    required this.title,
    required this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      elevation: 0,
      pressElevation: 0,
      onPressed: function,
      backgroundColor: backgroundColor,
      side: BorderSide(color: borderColor),
      label: Text(
        title,
        style: TextStyle(
          color: titleColor
        ),
      )
    );
  }
}
