import 'package:cosary_application_1/widgets/colors.dart';
import 'package:cosary_application_1/common/utils/utils.dart';
import 'package:cosary_application_1/common/widgets/custom_button.dart';
import 'package:cosary_application_1/common/widgets/forgetpassword.dart';
import 'package:cosary_application_1/common/widgets/roundedinputwidget.dart';
import 'package:cosary_application_1/common/widgets/roundedpasswordwidget.dart';
import 'package:cosary_application_1/features/auth/controller/auth_controller.dart';
import 'package:cosary_application_1/features/auth/screens/user_infomation_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

TextEditingController userNameController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  void senduserNameAndPassword() {
    String userName = userNameController.text.trim().toString();
    String password = passwordController.text.trim().toString();
    if (userName.isNotEmpty && password.isNotEmpty) {
      ref.read(authControllerProvider).signInWithUsername(context, userName, password);
    } else {
      showSnackBar(context: context, content: 'Fields are empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: whiteColor,
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.35,
                child: Image.asset(
                  'assets/iiumlogo.png',
                ),
              ),
              SizedBox(height: size.height * 0.1),
              RoundedInputWidget(
                hintText: 'Username',
                icon: Icons.people,
                emailController: userNameController,
              ),
              RoundedPasswordWidget(
                passwordController: passwordController,
              ),
              SizedBox(height: size.height * 0.05),
              SizedBox(
                width: size.width * 0.8,
                child: CustomButton(
                  onPressed: senduserNameAndPassword,
                  text: 'Login',
                  color: orangeColor,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              const ForgetPassword(),
            ],
          ),
        ),
      )),
    );
  }
}
