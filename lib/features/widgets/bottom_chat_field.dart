import 'dart:io';

import 'package:cosary_application_1/widgets/colors.dart';
import 'package:cosary_application_1/common/enum/message_enum.dart';
import 'package:cosary_application_1/common/providers/message_reply_provider.dart';
import 'package:cosary_application_1/common/utils/utils.dart';
import 'package:cosary_application_1/common/widgets/customiconbutton.dart';
import 'package:cosary_application_1/features/chat/controller/chat_controller.dart';
import 'package:cosary_application_1/features/widgets/message_reply_preview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;
  final String input;
  final bool imager;
  const BottomChatField({
    Key? key,
    required this.recieverUserId,
    required this.isGroupChat,
    required this.input,
    required this.imager,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final TextEditingController messageController = TextEditingController();
  bool isMessageIconEnabled = false;

  void sendTextMessage() async {
    if (messageController.text.isNotEmpty) {
      ref.read(chatControllerProvider).sentTextMessage(
            context,
            messageController.text.trim(),
            widget.recieverUserId,
            widget.isGroupChat,
            widget.input,
            widget.imager,
          );

      setState(() {
        messageController.text = '';
      });
    }
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref.read(chatControllerProvider).sentFileMessage(
          context,
          file,
          widget.recieverUserId,
          messageEnum,
          widget.isGroupChat,
          widget.input,
          widget.imager,
        );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
        Container(color: Colors.transparent),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: messageController,
                maxLines: 4,
                minLines: 1,
                onChanged: (value) {
                  value.isEmpty ? setState(() => isMessageIconEnabled = false) : setState(() => isMessageIconEnabled = true);
                },
                decoration: InputDecoration(
                  hintText: 'Message',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: senderMessageColor,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      style: BorderStyle.none,
                      width: 0,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: widget.imager ? true : false,
                        child: CustomIconButton(
                          onPressed: selectImage,
                          icon: Icons.camera_alt_outlined,
                          iconColor: orangeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            CustomIconButton(
              onPressed: sendTextMessage,
              icon: Icons.send_outlined,
              background: orangeColor,
              iconColor: Colors.white,
            ),
          ],
        ),
      ],
    );
  }
}
