import 'package:cosary_application_1/features/select_contacts/repository/select_chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(selectChatRepositoryProvider);
  return SelectContactController(
    ref: ref,
    selectChatRepository: selectContactRepository,
  );
});

class SelectContactController {
  final ProviderRef ref;
  final SelectChatRepository selectChatRepository;
  SelectContactController({
    required this.ref,
    required this.selectChatRepository,
  });

  void selectContact(String selectedContact, BuildContext context, bool isGroup) {
    selectChatRepository.selectContact(selectedContact, context, isGroup);
  }
}
