import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosary_application_1/widgets/colors.dart';
import 'package:cosary_application_1/common/widgets/error.dart';
import 'package:cosary_application_1/common/widgets/loader.dart';
import 'package:cosary_application_1/features/auth/controller/auth_controller.dart';
import 'package:cosary_application_1/features/auth/screens/login_screens.dart';
import 'package:cosary_application_1/features/auth/screens/user_infomation_screens.dart';
import 'package:cosary_application_1/features/landing/screens/landing_screen.dart';
import 'package:cosary_application_1/features/models/user_models.dart';
import 'package:cosary_application_1/firebase_options.dart';
import 'package:cosary_application_1/router.dart';
import 'package:cosary_application_1/screens/mobile_layout_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp UI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LoginScreen();
              }
              return const MobileLayoutScreen();
            },
            error: (err, trace) {
              return ErrorScreen(
                error: err.toString(),
              );
            },
            loading: () => const Loader(),
          ),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
