import 'package:flutter/material.dart';

class actionButton extends StatelessWidget {
  Function() ontap;
  String number;
  Icon icon;
  actionButton({
    Key? key,
    required this.ontap,
    this.number = '',
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Row(
        children: [
          icon,
          const SizedBox(width: 7,),
          Text(
            number,
            style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 16, color: Colors.grey
            ),
          )
        ],
      ),
    );
  }
}