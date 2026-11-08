import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_text_button.dart';
import 'package:permission_handler/permission_handler.dart';

class PickGalleryImage {
  final picker = ImagePicker();

  Future<File?> _pickImage(double rationX, double rationY) async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: CropAspectRatio(ratioX: rationX, ratioY: rationY),
          maxHeight: 1024,
          maxWidth: 1024,
          compressFormat: ImageCompressFormat.jpg,
        );
        if (croppedFile != null) {
          return File(croppedFile.path);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (err) {
      debugPrint(err.toString());
      return null;
    }
  }

  Future<File?> getImageFromGallery(double rationX, double rationY) async {
    if (await Permission.photos.request().isGranted ||
        await Permission.photos.request().isLimited) {
      return _pickImage(rationX, rationY);
    } else {
      await Get.defaultDialog(
        title: 'Mona Menu',
        titleStyle: const TextStyle(color: kBodyTextColor),
        content: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(tr('Please allow access to photos')),
        ),
        confirm: DefaultTextButton(
          label: tr('To Settings'),
          onPressed: () async {
            Get.back();
            await openAppSettings();
          },
        ),
      );
      return null;
    }
  }
}
