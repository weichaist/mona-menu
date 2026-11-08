import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantMenuItem {
  final String? title;
  final String? description;
  final List<String>? categories;
  final String? menuGroup;
  final int? price;
  final String? imageUrl;
  final int? ranking;
  final Timestamp? editedAt;
  final Timestamp? createdAt;
  final String? docId;
  final bool soldOut;

  RestaurantMenuItem({
    this.title,
    this.description,
    this.categories,
    this.menuGroup,
    this.price,
    this.imageUrl,
    this.ranking,
    this.editedAt,
    this.createdAt,
    this.docId,
    this.soldOut = false,
  });

  RestaurantMenuItem.fromFirestore(Map<String, dynamic> parsedJson)
    : title = parsedJson['title'],
      description = parsedJson['description'],
      categories = List.from(parsedJson['categories']),
      menuGroup = parsedJson['menuGroup'],
      ranking = parsedJson['ranking'],
      price = parsedJson['price'] as int,
      imageUrl = parsedJson['imageRef']['url'],
      docId = parsedJson['docId'],
      soldOut = parsedJson['soldOut'] ?? false,
      editedAt = parsedJson['editedAt'],
      createdAt = parsedJson['createdAt'];
}
