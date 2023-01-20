import 'package:cosary_application_1/widgets/colors.dart';
import 'package:cosary_application_1/common/widgets/loader.dart';
import 'package:cosary_application_1/features/chat/controller/chat_controller.dart';
import 'package:cosary_application_1/features/models/chat_contact.dart';
import 'package:cosary_application_1/features/models/group_models.dart';
import 'package:cosary_application_1/screens/mobile_chat_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CosaryList extends ConsumerWidget {
  const CosaryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: StreamBuilder<List<Group>>(
            stream: ref.watch(chatControllerProvider).chatCosaryGroups(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    var groupData = snapshot.data?[index];

                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              MobileChatScreen.routeName,
                              arguments: {
                                'name': groupData.name,
                                'uid': groupData.groupId,
                                'isGroupChat': true,
                                'input': 'cosary',
                              },
                            );
                            print(groupData.groupId);
                          },
                          // ignore: prefer_const_constructors
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              title: Text(
                                groupData!.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                // ignore: prefer_const_constructors
                                child: Text(
                                  groupData.lastMessage,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(groupData.groupPic),
                                radius: 30,
                              ),
                              trailing: Text(
                                DateFormat.Hm().format(groupData.timeSent),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Divider(color: dividerColor, indent: 85),
                      ],
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}
