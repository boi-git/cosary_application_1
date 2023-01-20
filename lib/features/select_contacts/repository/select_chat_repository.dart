import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosary_application_1/common/utils/utils.dart';
import 'package:cosary_application_1/features/models/user_models.dart';
import 'package:cosary_application_1/screens/mobile_chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectChatRepositoryProvider = Provider(
  (ref) => SelectChatRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectChatRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  SelectChatRepository({
    required this.auth,
    required this.firestore,
  });

  void selectContact(String selectedContact, BuildContext context, bool isGroup) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        if (selectedContact == userData.uid) {
          isFound = true;

          // ignore: use_build_context_synchronously
          Navigator.pushNamed(
            context,
            MobileChatScreen.routeName,
            arguments: {
              'name': userData.name,
              'uid': userData.uid,
              'isGroupChat': false,
              'input': '',
            },
          );
        }
      }

      if (!isFound) {
        showSnackBar(
          context: context,
          content: 'This username does not exist on this app.',
        );
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
