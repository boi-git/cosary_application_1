import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosary_application_1/features/models/user_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:cosary_application_1/common/repositories/common_firebase_storage_repositories.dart';
import 'package:cosary_application_1/common/utils/utils.dart';
import 'package:cosary_application_1/features/models/group_models.dart' as model;

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup(BuildContext context, String name, File profilePic, List<String> selectedUser) async {
    try {
      var newSelectedUser = selectedUser.toSet().toList();

      List<String> uids = [];

      for (int i = 0; i < newSelectedUser.length; i++) {
        var userCollection = await firestore.collection('users').where('uid', isEqualTo: newSelectedUser[i]).get();

        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()['uid']);
        }
        // }
        // for (int i = 0; i < selectedUser.length; i++) {
        //   uids.add(selectedUser[i]);
      }

      var groupId = const Uuid().v1();

      String profileUrl = await ref.read(commonFirebaseStorageRepositoryProvider).storeFileToFirebase(
            'group/$groupId',
            profilePic,
          );
      model.Group group = model.Group(
        senderId: auth.currentUser!.uid,
        name: name,
        groupId: groupId,
        lastMessage: '',
        groupPic: profileUrl,
        membersUid: [auth.currentUser!.uid, ...uids],
        timeSent: DateTime.now(),
      );

      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
