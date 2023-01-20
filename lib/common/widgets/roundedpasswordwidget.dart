import 'package:cosary_application_1/widgets/colors.dart';
import 'package:flutter/material.dart';

import 'textfieldcontainer.dart';

class RoundedPasswordWidget extends StatelessWidget {
  final TextEditingController passwordController;

  const RoundedPasswordWidget({
    Key? key,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'Password',
          border: InputBorder.none,
          suffixIcon: Icon(
            Icons.lock,
            color: darkColor,
          ),
        ),
      ),
    );
  }
}
