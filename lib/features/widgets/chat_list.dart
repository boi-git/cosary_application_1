import 'package:cosary_application_1/common/enum/message_enum.dart';
import 'package:cosary_application_1/common/providers/message_reply_provider.dart';
import 'package:cosary_application_1/common/widgets/loader.dart';
import 'package:cosary_application_1/features/chat/controller/chat_controller.dart';
import 'package:cosary_application_1/features/models/message.dart';
import 'package:cosary_application_1/features/widgets/my_message_card.dart';
import 'package:cosary_application_1/features/widgets/sender_message_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;
  final String input;
  const ChatList({
    Key? key,
    required this.recieverUserId,
    required this.isGroupChat,
    required this.input,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum messageEnum,
  ) {
    ref.read(messageReplyProvider.state).update(
          (state) => MessageReply(
            message,
            isMe,
            messageEnum,
          ),
        );
  }

  streamtype(String input) {
    switch (input) {
      case 'individual':
        return ref.read(chatControllerProvider).chatStream(widget.recieverUserId);
      case 'group':
        return ref.read(chatControllerProvider).groupChatStream(widget.recieverUserId);
      case 'cosary':
        return ref.read(chatControllerProvider).getCosaryGroupChatStream(widget.recieverUserId);
      default:
    }
  }

//getCosaryGroupChatStream
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: streamtype(widget.input),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController.jumpTo(messageController.position.maxScrollExtent);
          });

          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data == null ? 0 : snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var timeSent = DateFormat.Hm().format(messageData.timeSent);

              if (!messageData.isSeen && messageData.recieverid == FirebaseAuth.instance.currentUser!.uid) {
                ref.read(chatControllerProvider).setChatMessageSeen(
                      context,
                      widget.recieverUserId,
                      messageData.messageId,
                    );
              }
              if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  date: timeSent,
                  type: messageData.type,
                  repliedText: messageData.repliedMessage,
                  username: messageData.repliedTo,
                  repliedMessageType: messageData.repliedMessageType,
                  onLeftSwipe: () => onMessageSwipe(
                    messageData.text,
                    true,
                    messageData.type,
                  ),
                  isSeen: messageData.isSeen,
                );
              }
              return SenderMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
                username: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,
                onRightSwipe: () => onMessageSwipe(
                  messageData.text,
                  false,
                  messageData.type,
                ),
                repliedText: messageData.repliedMessage,
              );
            },
          );
        });
  }
}
