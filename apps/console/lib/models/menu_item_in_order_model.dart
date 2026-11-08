class MenuItemInOrder {
  final String? menuItemDocId;
  final String? menuItemTitle;
  final int? quantity;
  final double? price;
  final String? affiliateUserUid;
  final String? affiliatePostId;
  final double? totalPrice;

  MenuItemInOrder({
    this.menuItemDocId,
    this.menuItemTitle,
    this.quantity,
    this.price,
    this.affiliateUserUid,
    this.affiliatePostId,
    this.totalPrice,
  });

  MenuItemInOrder.fromFirestore(Map<String, dynamic> parsedJson)
    : menuItemDocId = parsedJson['menuItemId'],
      menuItemTitle = parsedJson['menuItemTitle'],
      quantity = parsedJson['quantity'] as int,
      affiliateUserUid = parsedJson['affiliateUserUid'],
      affiliatePostId = parsedJson['affiliatePostId'],
      price = double.parse(parsedJson['price'].toString()),
      totalPrice = double.parse(parsedJson['total'].toString());
}
