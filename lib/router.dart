import 'package:cosary_application_1/common/widgets/error.dart';
import 'package:cosary_application_1/features/auth/screens/login_screens.dart';
import 'package:cosary_application_1/features/auth/screens/user_infomation_screens.dart';
import 'package:cosary_application_1/features/group_details/screens/cosary_group_details.dart';
import 'package:cosary_application_1/features/landing/screens/landing_screen.dart';
import 'package:cosary_application_1/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:cosary_application_1/widgets/refine_user_profile.dart';
import 'package:cosary_application_1/screens/mobile_chat_screen.dart';
import 'package:cosary_application_1/screens/mobile_layout_screen.dart';
import 'package:cosary_application_1/widgets/user_profile.dart';
import 'package:flutter/material.dart';

import 'features/group_chat/screens/create_group_chat_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );

    case UserInformationScreen.routeName:
      var userName = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => UserInformationScreen(userName: userName),
      );

    case CosaryGroupDetails.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final uid = arguments['uid'];
      final input = arguments['input'];
      return MaterialPageRoute(
        builder: (context) => CosaryGroupDetails(uid: uid, input: input),
      );

    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'];
      final input = arguments['input'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
          isGroupChat: isGroupChat,
          input: input,
        ),
      );
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );

    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CreateGroupScreen(),
      );

    case MobileLayoutScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const MobileLayoutScreen(),
      );

    case LandingScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LandingScreen(),
      );

    case UserBackDetail.routeName:
      var userId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => UserBackDetail(username: userId),
      );

    case ProfileDetail.routeName:
      return MaterialPageRoute(
        builder: (context) => const ProfileDetail(),
      );

    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: ErrorScreen(error: 'This page does\' exist'),
              ));
  }
}
