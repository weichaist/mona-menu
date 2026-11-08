class MonaOrderInCart {
  final String? menuItemDocID;
  final String? menuItemTitle;
  final String? menuGroup;
  int? orderCount;
  final double? price;
  final String? affiliateUserUid;
  final String? affiliatePostId;
  final List<String>? menuItemCategories;
  final String? affiliateUserProfileUrl;
  final String? affiliateUserDisplayName;
  final double? totalPrice;
  final String? orderedBy;
  final DateTime? orderTimeStamp;

  MonaOrderInCart({
    this.menuItemDocID,
    this.menuItemTitle,
    this.menuGroup,
    this.orderCount,
    this.price,
    this.affiliateUserUid,
    this.menuItemCategories,
    this.affiliatePostId,
    this.affiliateUserProfileUrl,
    this.affiliateUserDisplayName,
    this.totalPrice,
    this.orderedBy,
    this.orderTimeStamp,
  });

  MonaOrderInCart.fromFirestore(Map<String, dynamic> parsedJson)
    : menuItemDocID = parsedJson['menuItemId'],
      menuItemTitle = parsedJson['menuItemTitle'],
      menuGroup = parsedJson['menuGroup'],
      orderCount = parsedJson['quantity'] as int,
      affiliateUserUid = parsedJson['affiliateUserUid'],
      affiliatePostId = parsedJson['affiliatePostId'],
      orderedBy = parsedJson['orderedBy'],
      orderTimeStamp = parsedJson['orderTimeStamp'].toDate(),
      affiliateUserProfileUrl = null,
      affiliateUserDisplayName = null,
      menuItemCategories = List<String>.from(
        parsedJson['menuItemCategories'].map((el) => el.toString()),
      ),
      price = double.parse(parsedJson['price'].toString()),
      totalPrice = double.parse(parsedJson['total'].toString());
}
