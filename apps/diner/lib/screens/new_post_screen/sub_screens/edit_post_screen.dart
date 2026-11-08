import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:mona_diner/constants.dart';
import 'package:mona_diner/controllers/user_post_controller.dart';
import 'package:mona_diner/models/mona_menu_post_model.dart';
import 'package:mona_diner/models/restaurant_menu_item_model.dart';
import 'package:mona_diner/screens/restaurant_screen/components/restaurant_dish_tile.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_icon_button.dart';
import 'package:mona_diner/screens/top_level_components/buttons/default_text_button.dart';
import 'package:mona_diner/utils/image_handler/pick_gallary_image.dart';
import 'package:mona_diner/utils/snackbar_dialog/build_get_snackbar.dart';

class EditPostScreen extends StatelessWidget {
  final RestaurantMenuItem menuItem;
  final MonaMenuPost? post;
  final String restaurantUid;
  const EditPostScreen({
    super.key,
    required this.menuItem,
    required this.restaurantUid,
    this.post,
  });
  @override
  Widget build(BuildContext context) {
    final postController = UserPostController.instance;
    if (post != null) {
      postController.initEditingProcess(post!);
    }
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            tr('Edit post'),
            style: const TextStyle(color: kAppBarTextColor),
          ),
          leading: DefaultIconButton(
            icon: CupertinoIcons.back,
            onTap: () {
              postController.resetController();
              Get.back();
              postController.initFetchOrderHistory();
            },
            size: 21,
            iconColor: kAppBarTextColor,
          ),
          actions: [
            Obx(
              () => !postController.editingProcess.value
                  ? DefaultTextButton(
                      label: tr('Post'),
                      color: postController.readyToPost()
                          ? kPrimaryColor
                          : kAppBarTextColor,
                      fontSize: 15,
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (postController.comment.value.length > 12) {
                          await postController.uploadNewMonaMenu(
                            restaurantUid,
                            menuItem,
                          );
                          postController.resetController();
                          postController.initFetchOrderHistory();
                        } else {
                          buildGetSnackbar(
                            tr('Please enter more than 12 characters!'),
                            tr('Reviews are too short'),
                          );
                        }
                      },
                    )
                  : DefaultTextButton(
                      label: '保存',
                      color: postController.readyToPost()
                          ? kPrimaryColor
                          : kAppBarTextColor,
                      fontSize: 15,
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (postController.comment.value.length > 12) {
                          await postController.saveEditedMonaMenu();
                          postController.resetController();
                          postController.initFetchOrderHistory();
                        } else {
                          buildGetSnackbar(
                            tr('Please enter more than 12 characters!'),
                            tr('Reviews are too short'),
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
        body: EditPostScreenBody(menuItem: menuItem),
      ),
    );
  }
}

class EditPostScreenBody extends StatelessWidget {
  const EditPostScreenBody({super.key, required this.menuItem});

  final RestaurantMenuItem menuItem;

  @override
  Widget build(BuildContext context) {
    final postController = UserPostController.instance;
    return Unfocuser(
      child: SingleChildScrollView(
        child: Column(
          children: [
            RestaurantDishTile(restaurantMenuItem: menuItem),
            TextField(
              minLines: 6,
              maxLines: 9,
              controller: postController.commentController,
              onChanged: (val) {
                postController.comment.value = val;
              },
              decoration: InputDecoration(
                hintText: tr('Please tell everyone why you like it!'),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 18,
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryLightColor),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryLightColor),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 18, bottom: 9),
                  child: Text(
                    tr('Added photos (up to 6)'),
                    style: const TextStyle(color: kAppBarTextColor),
                  ),
                ),
              ],
            ),
            GridView.builder(
              itemCount: 6,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(9.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 9.0,
                crossAxisSpacing: 9.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Obx(
                  () => postController.imageFiles.length <= index
                      ? GestureDetector(
                          onTap: () async {
                            File? image = await PickGalleryImage()
                                .getImageFromGallery(1, 1);
                            if (image != null) {
                              postController.imageFiles.add(image.path);
                            }
                          },
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: kPrimaryLightColor,
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: const Center(
                                  child: Icon(
                                    CupertinoIcons.add_circled,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 6.0,
                                  right: 9.0,
                                ),
                                child: Text(
                                  (index + 1).toString(),
                                  style: const TextStyle(color: kPrimaryColor),
                                ),
                              ),
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            File? image = await PickGalleryImage()
                                .getImageFromGallery(1, 1);
                            if (image != null) {
                              postController.imageFiles[index] = image.path;
                            }
                          },
                          child: Stack(
                            children: [
                              postController.imageFiles[index].startsWith(
                                    'https://',
                                  )
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: kPrimaryLightColor,
                                        borderRadius: BorderRadius.circular(9),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            postController.imageFiles[index],
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        color: kPrimaryLightColor,
                                        borderRadius: BorderRadius.circular(9),
                                        image: DecorationImage(
                                          image: FileImage(
                                            File(
                                              postController.imageFiles[index],
                                            ),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              const Positioned(
                                top: 0,
                                right: 0,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 6.0,
                                    right: 9.0,
                                  ),
                                  child: Icon(
                                    CupertinoIcons
                                        .rectangle_fill_on_rectangle_angled_fill,
                                    color: kPrimaryColor,
                                    size: 18,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 3,
                                left: 3,
                                child: GestureDetector(
                                  onTap: () {
                                    postController.imageFiles.removeAt(index);
                                  },
                                  child: const Icon(
                                    CupertinoIcons.clear_thick_circled,
                                    color: kPrimaryColor,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
