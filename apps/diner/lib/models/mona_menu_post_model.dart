import 'package:cloud_firestore/cloud_firestore.dart';

class MonaMenuPost {
  final String? menuItemName;
  final List<String>? menuItemCategories;
  final String? menuItemId;
  final String? restaurantUid;
  final String? userComment;
  final List<String>? userImages;
  final List<Map<String, String>>? userImagesWithRef;
  final String? postedBy;
  final DateTime? postedAt;
  final String? postId;

  MonaMenuPost({
    this.menuItemName,
    this.menuItemCategories,
    this.menuItemId,
    this.restaurantUid,
    this.userComment,
    this.userImages,
    this.userImagesWithRef,
    this.postedBy,
    this.postId,
    this.postedAt,
  });

  MonaMenuPost.fromFirestore(Map<String, dynamic> parsedJson)
    : menuItemName = parsedJson['menuItemName'],
      menuItemCategories = List<String>.from(parsedJson['menuItemCategories']),
      menuItemId = parsedJson['menuItemId'],
      restaurantUid = parsedJson['restaurantUid'],
      userComment = parsedJson['comment'],
      userImages = List<String>.from(
        parsedJson['images'].map((el) => el['url']),
      ),
      userImagesWithRef = List<Map<String, String>>.from(
        parsedJson['images'].map((el) => Map<String, String>.from(el)),
      ),
      postedBy = parsedJson['postedBy'],
      postedAt = parsedJson['postedAt'].toDate(),
      postId = parsedJson['postId'];

  MonaMenuPost.fromAlgolia(Map<String, dynamic> parsedJson)
    : menuItemName = parsedJson['menuItemName'],
      menuItemCategories = List<String>.from(parsedJson['menuItemCategories']),
      menuItemId = parsedJson['menuItemId'],
      restaurantUid = parsedJson['restaurantUid'],
      userComment = parsedJson['comment'],
      userImages = List<String>.from(
        parsedJson['images'].map((el) => el['url']),
      ),
      userImagesWithRef = List<Map<String, String>>.from(
        parsedJson['images'].map((el) => Map<String, String>.from(el)),
      ),
      postedBy = parsedJson['postedBy'],
      postedAt = Timestamp(
        parsedJson['postedAt']['_seconds'],
        parsedJson['postedAt']['_nanoseconds'],
      ).toDate(),
      postId = parsedJson['postId'];
}
