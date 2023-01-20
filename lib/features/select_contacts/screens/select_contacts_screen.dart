import 'package:cosary_application_1/features/select_contacts/controller/select_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const String routeName = '/select-contact';
  const SelectContactsScreen({Key? key}) : super(key: key);

  void selectContact(WidgetRef ref, String selectedContact, BuildContext context) {
    ref.read(selectContactControllerProvider).selectContact(selectedContact, context, true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select contact'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
              ),
            ),
          ],
        ),
        body: Center(
          child: GestureDetector(onTap: () => selectContact(ref, '001', context), child: const Text('object')),
        ));
  }
}
