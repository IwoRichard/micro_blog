import 'package:flutter/material.dart';

//Login/Signup Textfields
class LoginSignUpTextField extends StatefulWidget {
  TextEditingController textController;
  TextInputAction inputAction;
  String label;
  int? maxLines;
  bool showMaxLength;
  int? maxLength;
  bool showObscureIcon;
  LoginSignUpTextField({
    Key? key,
    required this.textController,
    required this.inputAction,
    required this.label,
    this.maxLines = 1,
    this.showMaxLength = false,
    this.maxLength,
    this.showObscureIcon = false,
  }) : super(key: key);

  @override
  State<LoginSignUpTextField> createState() => _LoginSignUpTextFieldState();
}

class _LoginSignUpTextFieldState extends State<LoginSignUpTextField> {

  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      maxLength: widget.showMaxLength ? widget.maxLength : null,
      controller: widget.textController,
      textInputAction: widget.inputAction,
      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.blue.shade700,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: widget.showObscureIcon == true ? IconButton(
          onPressed: (){
            setState(() {
              obscureText = !obscureText;
            });
          }, 
          icon: obscureText ? 
          const Icon(Icons.visibility, color: Colors.grey,) : 
          const Icon(Icons.visibility_off, color: Colors.grey,)
        ) : null,
        labelText: widget.label,
        labelStyle: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black.withOpacity(.5)
        ),
        floatingLabelStyle: TextStyle(color: Colors.blue.shade700),
        filled: true,
        fillColor: Colors.blue.shade100.withOpacity(.19),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade700, width: 1.7)
        ),
        counterText: widget.showMaxLength ? null : '',
      ),
    );
  }
}


//Edit Profile TextFields
class EditProfileTextField extends StatefulWidget {
  String hintextt;
  TextEditingController textController;
  int maxlines;
  int maxlength;
  bool showMaxLength; 
  EditProfileTextField({
    Key? key,
    required this.hintextt,
    required this.textController,
    this.maxlines = 1,
    this.maxlength = 100,
    this.showMaxLength = true,
  }) : super(key: key);

  @override
  State<EditProfileTextField> createState() => _EditProfileTextFieldState();
}

class _EditProfileTextFieldState extends State<EditProfileTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: widget.showMaxLength ? widget.maxlength : null, 
      maxLines: widget.maxlines,
      controller: widget.textController,
      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        hintText: widget.hintextt,
        hintStyle: const TextStyle(fontSize: 15,color: Colors.grey),
      ),
    );
  }
}