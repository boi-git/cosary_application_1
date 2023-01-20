import 'dart:io';

import 'package:cosary_application_1/widgets/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: darkColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      content: Text(
        content,
        style: TextStyle(color: whiteColor),
      ),
    ),
  );
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
      image = await _cropImage(imageFile: image);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Future<PlatformFile?> pickFileFromPhone(BuildContext context) async {
  PlatformFile? pdf;
  try {
    final result = await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: false);

    if (result?.files.first != null) {
      // var fileBytes = result!.files.first.bytes;
      // var fileName = result.files.first.name;
      pdf = result!.files.first;
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return pdf;
}

Future _cropImage({required File imageFile}) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(sourcePath: imageFile.path);
  if (croppedFile == null) return;
  return File(croppedFile.path);
}
