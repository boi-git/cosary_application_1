// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cosary_application_1/features/location/screens/location.dart';
import 'package:cosary_application_1/widgets/colors.dart';
import 'package:cosary_application_1/features/auth/controller/auth_controller.dart';
import 'package:cosary_application_1/features/auth/screens/login_screens.dart';
import 'package:cosary_application_1/features/group_chat/screens/create_group_chat_screen.dart';
import 'package:cosary_application_1/features/landing/screens/landing_screen.dart';
import 'package:cosary_application_1/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:cosary_application_1/features/widgets/contacts_list.dart';
import 'package:cosary_application_1/features/widgets/cosary_list.dart';
import 'package:cosary_application_1/widgets/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);
  static const routeName = '/mobile-layout--screen';

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tabBarController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 10,
          backgroundColor: backgroundColor,
          centerTitle: false,
          title: const Text(
            'Cosary',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: const Text('Profile'),
                    onTap: () {
                      Future(() => Navigator.pushNamed(context, ProfileDetail.routeName));
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('Create Group'),
                    onTap: () {
                      Future(() => Navigator.pushNamed(context, CreateGroupScreen.routeName));
                    },
                  ),
                  PopupMenuItem(
                    onTap: _signOut,
                    child: const Text('Sign out'),
                  )
                ];
              },
            ),
          ],
          bottom: TabBar(
            controller: tabBarController,
            indicatorColor: orangeColor,
            indicatorWeight: 3,
            labelColor: orangeColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: 'COSARY',
              ),
              Tab(
                text: 'CHAT',
              ),
              Tab(
                text: 'LOCATION',
              ),
            ],
          ),
        ),
        // body: const ContactsList(),
        body: TabBarView(controller: tabBarController, children: [
          CosaryList(),
          ContactsList(),
          Location(),
        ]),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.pushNamed(context, SelectContactsScreen.routeName);
        //   },
        //   backgroundColor: tabColor,
        //   child: const Icon(
        //     Icons.search,
        //     color: Colors.white,
        //   ),
        // ),
      ),
    );
  }
}
