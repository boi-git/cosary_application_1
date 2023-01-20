import 'package:cosary_application_1/widgets/colors.dart';
import 'package:cosary_application_1/common/widgets/error.dart';
import 'package:cosary_application_1/common/widgets/loader.dart';
import 'package:cosary_application_1/features/chat/controller/chat_controller.dart';
import 'package:cosary_application_1/features/models/chat_contact.dart';
import 'package:cosary_application_1/features/models/user_models.dart';
import 'package:cosary_application_1/screens/mobile_chat_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final selectedGroupContacts = StateProvider<List<String>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactsIndex = [];

  void selectContact(int index, String selectedUser) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.removeAt(index);
    } else {
      selectedContactsIndex.add(index);
    }

    setState(() {});
    ref.read(selectedGroupContacts.state).update((state) => [...state, selectedUser]);
  }

  @override
  Widget build(BuildContext context) {
    //  return ref.read(chatControllerProvider)(
    //   data: (contactList) => Expanded(
    //     child: ListView.builder(
    //         itemCount: contactList.length,
    //         itemBuilder: (context, index) {
    //           final contact = contactList[index];
    //           return InkWell(
    //             onTap: () => selectContact(index, contact),
    //             child: Padding(
    //               padding: const EdgeInsets.only(bottom: 8),
    //               child: ListTile(
    //                 title: Text(
    //                   contact.displayName,
    //                   style: const TextStyle(
    //                     fontSize: 18,
    //                   ),
    //                 ),
    //                 leading: selectedContactsIndex.contains(index)
    //                     ? IconButton(
    //                         onPressed: () {},
    //                         icon: const Icon(Icons.done),
    //                       )
    //                     : null,
    //               ),
    //             ),
    //           );
    //         }),
    //   ),
    //   error: (err, trace) => ErrorScreen(
    //     error: err.toString(),
    //   ),
    //   loading: () => const Loader(),
    // );

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<ChatContact>>(
          stream: ref.watch(chatControllerProvider).chatContact(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  var chatContactData = snapshot.data![index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          selectContact(index, chatContactData.contactId);
                          // Navigator.pushNamed(
                          //   context,
                          //   MobileChatScreen.routeName,
                          //   arguments: {
                          //     'name': chatContactData.name,
                          //     'uid': chatContactData.contactId,
                          //   },
                          // );
                        },
                        // ignore: prefer_const_constructors
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                              dense: true,
                              // visualDensity: VisualDensity(vertical: )
                              title: Text(
                                chatContactData.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(chatContactData.profilePic),
                                radius: 20,
                              ),
                              trailing: selectedContactsIndex.contains(index) ? const Icon(Icons.done) : null),
                        ),
                      ),
                      const Divider(color: dividerColor, indent: 85),
                    ],
                  );
                },
              );
            }
          }),
    );
  }
}
