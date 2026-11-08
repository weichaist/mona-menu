class OrderInCart {
  final String? menuItemDocID;
  final String? menuItemTitle;
  final String? menuGroup;
  int? orderCount;
  final double? price;
  final List<String>? menuItemCategories;

  OrderInCart({
    this.menuItemDocID,
    this.menuItemTitle,
    this.menuGroup,
    this.orderCount,
    this.price,
    this.menuItemCategories,
  });

  OrderInCart.fromFirestore(Map<String, dynamic> parsedJson)
    : menuItemDocID = parsedJson['menuItemId'],
      menuItemTitle = parsedJson['menuItemTitle'],
      menuGroup = parsedJson['menuGroup'],
      orderCount = parsedJson['quantity'],
      menuItemCategories = List<String>.from(parsedJson['menuItemCategories']),
      price = double.parse(parsedJson['price'].toString());
}
