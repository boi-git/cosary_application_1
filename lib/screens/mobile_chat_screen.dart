// ignore_for_file: must_be_immutable, prefer_interpolation_to_compose_strings, avoid_print
import 'package:cosary_application_1/common/utils/utils.dart';
import 'package:cosary_application_1/features/chat/controller/chat_controller.dart';
import 'package:cosary_application_1/widgets/colors.dart';

import 'package:cosary_application_1/common/widgets/loader.dart';
import 'package:cosary_application_1/features/auth/controller/auth_controller.dart';
import 'package:cosary_application_1/features/group_details/screens/cosary_group_details.dart';

import 'package:cosary_application_1/features/models/user_models.dart';
import 'package:cosary_application_1/features/widgets/bottom_chat_field.dart';
import 'package:cosary_application_1/features/widgets/chat_list.dart';
import 'package:cosary_application_1/widgets/refine_user_profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileChatScreen extends ConsumerStatefulWidget {
  static const routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String input;

  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.input,
  }) : super(key: key);

  @override
  ConsumerState<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends ConsumerState<MobileChatScreen> {
  bool imager = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: widget.isGroupChat
            ? GestureDetector(
                onTap: (() {
                  Navigator.pushNamed(
                    context,
                    CosaryGroupDetails.routeName,
                    arguments: {'uid': widget.uid, 'input': widget.input},
                  );
                }),
                child: Text(widget.name))
            : StreamBuilder<UserModel>(
                stream: ref.read(authControllerProvider).userDataById(widget.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader();
                  }
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, UserBackDetail.routeName, arguments: widget.uid);
                    },
                    child: Column(
                      children: [
                        Text(widget.name),
                        Text(
                          snapshot.data!.isOnline ? 'online' : 'offline',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  );
                }),
        centerTitle: false,
        actions: [
          Visibility(
            visible: widget.isGroupChat ? false : true,
            child: PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: const Text('Allow Image?'),
                      onTap: () {
                        setState(() {
                          imager = !imager;
                          ref.read(chatControllerProvider).setImager(context, widget.uid, imager);
                          showSnackBar(context: context, content: 'allow image?  ${imager.toString()}');
                        });
                      },
                    )
                  ];
                }),
          )
        ],
      ),
      body: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Expanded(
            child: ChatList(
              recieverUserId: widget.uid,
              isGroupChat: widget.isGroupChat,
              input: widget.input,
            ),
          ),
          widget.isGroupChat //always true
              ? BottomChatField(
                  recieverUserId: widget.uid,
                  isGroupChat: widget.isGroupChat,
                  input: widget.input,
                  imager: true,
                )
              : FutureBuilder(
                  future: ref.read(chatControllerProvider).getImager(widget.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                    } else {
                      final recdata = snapshot.data!;

                      return BottomChatField(
                        recieverUserId: widget.uid,
                        isGroupChat: widget.isGroupChat,
                        input: widget.input,
                        imager: recdata,
                      );
                    }
                    return const Loader();
                  })
        ],
      ),
    );
  }
}
