import 'package:cosary_application_1/widgets/colors.dart';
import 'package:cosary_application_1/common/widgets/textfieldcontainer.dart';
import 'package:flutter/material.dart';

class RoundedInputWidget extends StatelessWidget {
  final TextEditingController emailController;
  final String hintText;
  final IconData icon;

  const RoundedInputWidget({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.emailController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: emailController,
        decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            suffixIcon: Icon(
              icon,
              color: darkColor,
            )),
      ),
    );
  }
}
