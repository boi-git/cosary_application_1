import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosary_application_1/common/enum/message_enum.dart';
import 'package:cosary_application_1/common/providers/message_reply_provider.dart';
import 'package:cosary_application_1/common/repositories/common_firebase_storage_repositories.dart';
import 'package:cosary_application_1/common/utils/utils.dart';
import 'package:cosary_application_1/features/models/chat_contact.dart';
import 'package:cosary_application_1/features/models/group_models.dart';
import 'package:cosary_application_1/features/models/message.dart';
import 'package:cosary_application_1/features/models/user_models.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider(
  ((ref) => ChatRepository(
        firestore: FirebaseFirestore.instance,
        auth: FirebaseAuth.instance,
      )),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ChatContact>> getChatContact() {
    return firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').snapshots().asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());

        var userData = await firestore.collection('users').doc(chatContact.contactId).get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
            imager: chatContact.imager));
      }
      return contacts;
    });
  }

  Stream<List<Group>> getChatGroups() {
    return firestore.collection('groups').snapshots().map((event) {
      List<Group> groups = [];
      for (var document in event.docs) {
        var group = Group.fromMap(document.data());
        if (group.membersUid.contains(auth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }

  Stream<List<Group>> getCosaryGroups() {
    return firestore.collection('cosary_group').snapshots().map((event) {
      List<Group> groups = [];
      for (var document in event.docs) {
        var group = Group.fromMap(document.data());
        if (group.membersUid.contains(auth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }

  Future<Group> getFilterGroups(String groupId) async {
    return firestore.collection('groups').doc(groupId).get().then((value) => Group.fromMap(value.data()!));
  }

  Future<Group> getFilterosaryGroups(String groupId) async {
    return firestore.collection('cosary_group').doc(groupId).get().then((value) => Group.fromMap(value.data()!));
  }

  Future<UserModel> getFilterUser(String uid) async {
    return firestore.collection('users').doc(uid).get().then((value) => UserModel.fromMap(value.data()!));
  }

  Future<bool> getImager(String uid) async {
    print(uid);
    print(auth.currentUser!.uid);
    ChatContact? inputChatContact;
    ChatContact? outputChatContact;
    var inputDataMap = await firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(uid).get();
    var outputDataMap = await firestore.collection('users').doc(uid).collection('chats').doc(auth.currentUser!.uid).get();

    if (inputDataMap.exists && outputDataMap.exists) {
      inputChatContact = ChatContact.fromMap(inputDataMap.data()!);
      outputChatContact = ChatContact.fromMap(outputDataMap.data()!);
      if (inputChatContact.imager && outputChatContact.imager) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  Stream<List<Message>> getChatStream(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  Stream<List<Message>> getGroupChatStream(String groudId) {
    return firestore.collection('groups').doc(groudId).collection('chats').orderBy('timeSent').snapshots().map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }

      return messages;
    });
  }

  Stream<List<Message>> getCosaryGroupChatStream(String groudId) {
    return firestore
        .collection('cosary_group')
        .doc(
          groudId,
        )
        .collection('chats')
        .orderBy('timeSent')
        .snapshots()
        .map((
      event,
    ) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void _saveDatatoContactsSubCollection(UserModel senderUserData, UserModel? recieverUserData, String text, DateTime timeSent, String recieverUserId,
      bool isGroupChat, String input, bool imager) async {
    print(input);
    if (isGroupChat) {
      if (input == 'group') {
        await firestore.collection('groups').doc(recieverUserId).update({
          'lastMessage': text,
          'timeSent': DateTime.now().microsecondsSinceEpoch,
        });
      } else {
        await firestore.collection('cosary_group').doc(recieverUserId).update({
          'lastMessage': text,
          'timeSent': DateTime.now().microsecondsSinceEpoch,
        });
      }
    } else {
      var recieverChatContatct = ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text,
        imager: imager,
      );

      await firestore.collection('users').doc(recieverUserId).collection('chats').doc(auth.currentUser!.uid).set(
            recieverChatContatct.toMap(),
          );
      var senderChatContatct = ChatContact(
        name: recieverUserData!.name,
        profilePic: recieverUserData.profilePic,
        contactId: recieverUserData.uid,
        timeSent: timeSent,
        lastMessage: text,
        imager: false,
      );

      await firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(recieverUserId).set(
            senderChatContatct.toMap(),
          );
    }
  }

  void _saveMessageToMessageSubcollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUsername,
    required String? recieverUserName,
    required bool isGroupChat,
    required String input,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      recieverid: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUsername
              : recieverUserName ?? '',
      repliedMessageType: messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );
    if (isGroupChat) {
      if (input == 'group') {
        await firestore.collection('groups').doc(recieverUserId).collection('chats').doc(messageId).set(
              message.toMap(),
            );
      } else {
        await firestore.collection('cosary_group').doc(recieverUserId).collection('chats').doc(messageId).set(message.toMap());
      }
    } else {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
    }
  }

  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String recieverUserId,
      required UserModel senderUser,
      required MessageReply? messageReply,
      required bool isGroupChat,
      required String input,
      required bool imager}) async {
    try {
      var timeSent = DateTime.now();
      UserModel? receiverUserData;
      if (!isGroupChat) {
        var userDataMap = await firestore.collection('users').doc(recieverUserId).get();

        receiverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      var messageId = const Uuid().v1();

      _saveDatatoContactsSubCollection(senderUser, receiverUserData, text, timeSent, recieverUserId, isGroupChat, input, imager);

      _saveMessageToMessageSubcollection(
        recieverUserId: recieverUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
        recieverUserName: receiverUserData?.name,
        username: senderUser.name,
        messageReply: messageReply,
        senderUsername: senderUser.name,
        isGroupChat: isGroupChat,
        input: input,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String recieverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
    required bool isGroupChat,
    required String input,
    required bool imager,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl = await ref.read(commonFirebaseStorageRepositoryProvider).storeFileToFirebase(
            'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
            file,
          );

      UserModel? recieverUserData;
      if (!isGroupChat) {
        var userDataMap = await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.pdf:
          contactMsg = ':📚 Document:';
          break;
        default:
          contactMsg = 'GIF';
      }

      _saveDatatoContactsSubCollection(senderUserData, recieverUserData, contactMsg, timeSent, recieverUserId, isGroupChat, input, imager);

      _saveMessageToMessageSubcollection(
        recieverUserId: recieverUserId,
        text: imageUrl,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUserData.name,
        messageType: messageEnum,
        messageReply: messageReply,
        recieverUserName: recieverUserData?.name,
        senderUsername: senderUserData.name,
        isGroupChat: isGroupChat,
        input: input,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setImager(
    BuildContext context,
    String recieverUserId,
    bool allowimage,
  ) async {
    try {
      await firestore.collection('users').doc(recieverUserId).collection('chats').doc(auth.currentUser!.uid).update({'imager': allowimage});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void updateDp(
    BuildContext context,
    File? profilePic,
    ProviderRef ref,
  ) async {
    try {
      String uid = auth.currentUser!.uid;

      String photoUrl = 'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      if (profilePic != null) {
        photoUrl = await ref.read(commonFirebaseStorageRepositoryProvider).storeFileToFirebase(
              'profilePic/$uid',
              profilePic,
            );
      }
      await firestore.collection('users').doc(uid).update({'profilePic': photoUrl});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void updateBg(
    BuildContext context,
    File? profilePic,
    ProviderRef ref,
  ) async {
    try {
      String uid = auth.currentUser!.uid;

      String photoUrl = 'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      if (profilePic != null) {
        photoUrl = await ref.read(commonFirebaseStorageRepositoryProvider).storeFileToFirebase(
              'bgPic/$uid',
              profilePic,
            );
      }
      await firestore.collection('users').doc(uid).update({'bgPic': photoUrl});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
