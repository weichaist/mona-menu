import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mona_console/constants.dart';
import 'package:mona_console/top_level_components/buttons/default_text_button.dart';
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
    if (await Permission.photos.request().isGranted) {
      return _pickImage(rationX, rationY);
    } else {
      await Get.defaultDialog(
        title: 'Mona Menu',
        titleStyle: const TextStyle(color: kBodyTextColor),
        content: const Padding(
          padding: EdgeInsets.all(18.0),
          child: Text('写真へのアクセスを許可してください'),
        ),
        confirm: DefaultTextButton(
          label: '「設定」へ',
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
