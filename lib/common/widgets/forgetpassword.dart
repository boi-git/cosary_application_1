import 'package:cosary_application_1/widgets/colors.dart';
import 'package:cosary_application_1/features/auth/screens/user_infomation_screens.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Forget Password?',
          style: TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: () {},
          child: const Text(
            ' Click Here',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
