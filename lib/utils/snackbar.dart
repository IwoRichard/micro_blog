import 'package:flutter/material.dart';

snackBar(String content, BuildContext context, Color color){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      backgroundColor: color
    )
  );
}