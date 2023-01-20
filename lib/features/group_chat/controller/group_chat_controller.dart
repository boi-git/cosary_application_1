import 'dart:io';

import 'package:cosary_application_1/features/group_chat/repository/group_chat_repository.dart';
import 'package:cosary_application_1/features/models/user_models.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupControllerProvider = Provider((ref) {
  final groupRepository = ref.read(groupRepositoryProvider);
  return GroupController(
    groupRepository: groupRepository,
    ref: ref,
  );
});

class GroupController {
  final GroupRepository groupRepository;
  final ProviderRef ref;
  GroupController({
    required this.groupRepository,
    required this.ref,
  });

  void createGroup(BuildContext context, String name, File profilePic, List<String> selectedUser) {
    groupRepository.createGroup(context, name, profilePic, selectedUser);
  }
}
