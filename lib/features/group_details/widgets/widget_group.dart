// ignore_for_file: prefer_const_constructors

import 'package:cosary_application_1/features/models/group_models.dart';
import 'package:cosary_application_1/features/models/user_models.dart';
import 'package:cosary_application_1/screens/mobile_chat_screen.dart';
import 'package:cosary_application_1/widgets/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class sub_menu extends StatelessWidget {
  final VoidCallback onPressed;
  const sub_menu({
    Key? key,
    required this.userfield,
    required this.onPressed,
  }) : super(key: key);

  final UserModel userfield;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userfield.name,
                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 32),
                ),
                Text(
                  userfield.type,
                  style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                ),
              ],
            ),
            const Spacer(),
            Visibility(
              visible: FirebaseAuth.instance.currentUser!.uid == userfield.uid ? false : true,
              child: InkWell(
                splashColor: orangeColor,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    MobileChatScreen.routeName,
                    arguments: {'name': userfield.name, 'uid': userfield.uid, 'isGroupChat': false, 'input': 'individual'},
                  );
                },
                child: Icon(
                  Icons.message,
                  color: orangeColor,
                ),
              ),
            )
          ],
        ),
        const Spacer(),
        Text(
          'Level',
          style: TextStyle(color: orangeColor, fontWeight: FontWeight.w500, fontSize: 16),
        ),
        const Text(
          '4',
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
        ),
        Text(
          'Degree',
          style: TextStyle(color: orangeColor, fontWeight: FontWeight.w500, fontSize: 16),
        ),
        const Text(
          'Computer Science',
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
        ),
        Text(
          'Major',
          style: TextStyle(color: orangeColor, fontWeight: FontWeight.w500, fontSize: 16),
        ),
        const Text(
          'Software Engineering',
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
        ),
        const Spacer(),
        Text(
          'About',
          style: TextStyle(color: orangeColor, fontWeight: FontWeight.w500, fontSize: 16),
        ),
        const Text(
          'Im at my Senior Year',
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
        ),
        const Spacer(),
      ],
    );
  }
}

class sub_menu_group extends StatelessWidget {
  final String input;
  const sub_menu_group({
    Key? key,
    required this.groupfield,
    required this.input,
  }) : super(key: key);

  final Group groupfield;

  @override
  Widget build(BuildContext context) {
    print(input);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupfield.name,
                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 32),
                ),
                Text(
                  groupfield.name,
                  style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
        const Spacer(),
        if (input == 'cosary') ...[
          Text(
            'Location',
            style: TextStyle(color: orangeColor, fontWeight: FontWeight.w500, fontSize: 16),
          ),
          const Text(
            'Kict Block A',
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
          ),
          Text(
            'Time',
            style: TextStyle(color: orangeColor, fontWeight: FontWeight.w500, fontSize: 16),
          ),
          const Text(
            '8:00 am - 10:00am',
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
          ),
          const Spacer(),
          Text(
            'Lecture',
            style: TextStyle(color: orangeColor, fontWeight: FontWeight.w500, fontSize: 16),
          ),
          const Text(
            'Dr Newtow',
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
          ),
        ],
        const Spacer(),
      ],
    );
  }
}
