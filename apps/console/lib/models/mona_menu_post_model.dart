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
  final String? monaMenuId;

  MonaMenuPost({
    this.menuItemName,
    this.menuItemCategories,
    this.menuItemId,
    this.restaurantUid,
    this.userComment,
    this.userImages,
    this.userImagesWithRef,
    this.postedBy,
    this.monaMenuId,
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
      monaMenuId = parsedJson['monaMenuId'];
}
