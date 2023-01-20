import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosary_application_1/common/enum/message_enum.dart';
import 'package:cosary_application_1/common/providers/message_reply_provider.dart';
import 'package:cosary_application_1/features/auth/controller/auth_controller.dart';
import 'package:cosary_application_1/features/models/chat_contact.dart';
import 'package:cosary_application_1/features/models/group_models.dart';
import 'package:cosary_application_1/features/models/message.dart';
import 'package:cosary_application_1/features/models/user_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cosary_application_1/features/chat/repository/chat_repository.dart';

final chatControllerProvider = Provider(((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
}));

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContact() {
    return chatRepository.getChatContact();
  }

  Stream<List<Group>> chatGroups() {
    return chatRepository.getChatGroups();
  }

  Stream<List<Group>> chatCosaryGroups() {
    return chatRepository.getCosaryGroups();
  }

  Future<Group> getFilterosaryGroups(String groupId) {
    return chatRepository.getFilterosaryGroups(groupId);
  }

  Future<Group> getFilterGroups(String groupId) {
    return chatRepository.getFilterGroups(groupId);
  }

  Future<UserModel> getFilterUser(String userId) {
    return chatRepository.getFilterUser(userId);
  }

  Future<bool> getImager(String recieveruid) {
    return chatRepository.getImager(
      recieveruid,
    );
  }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  Stream<List<Message>> groupChatStream(String groupId) {
    return chatRepository.getGroupChatStream(groupId);
  }

  Stream<List<Message>> getCosaryGroupChatStream(String groupId) {
    return chatRepository.getCosaryGroupChatStream(groupId);
  }

  void sentTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
    bool isGroupChat,
    String input,
    bool imager,
  ) {
    final messageReply = ref.read(messageReplyProvider);

    ref.read(userDataAuthProvider).whenData((value) => chatRepository.sendTextMessage(
          context: context,
          text: text,
          recieverUserId: recieverUserId,
          senderUser: value!,
          messageReply: messageReply,
          isGroupChat: isGroupChat,
          input: input,
          imager: imager,
        ));
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sentFileMessage(
    BuildContext context,
    File file,
    String recieverUserId,
    MessageEnum messageEnum,
    bool isGroupChat,
    String input,
    bool imager,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) => chatRepository.sendFileMessage(
        context: context,
        file: file,
        recieverUserId: recieverUserId,
        senderUserData: value!,
        messageEnum: messageEnum,
        ref: ref,
        messageReply: messageReply,
        isGroupChat: isGroupChat,
        input: input,
        imager: imager));
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(
      context,
      recieverUserId,
      messageId,
    );
  }

  void setImager(
    BuildContext context,
    String recieverUserId,
    bool allowimage,
  ) {
    chatRepository.setImager(context, recieverUserId, allowimage);
  }

  void updateDp(
    BuildContext context,
    File? profilePic,
  ) {
    chatRepository.updateDp(context, profilePic, ref);
  }

  void updateBg(
    BuildContext context,
    File? profilePic,
  ) {
    chatRepository.updateBg(context, profilePic, ref);
  }
}
