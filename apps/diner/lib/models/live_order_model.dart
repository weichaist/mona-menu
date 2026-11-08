class LiveOrder {
  final String? orderedBy;
  final String? restaurantUid;
  final DateTime? orderTimeStamp;
  final List<String>? menuItemTitles;
  final List<String>? menuItemIds;
  final String? orderId;

  LiveOrder({
    this.orderedBy,
    this.restaurantUid,
    this.orderTimeStamp,
    this.menuItemTitles,
    this.menuItemIds,
    this.orderId,
  });

  LiveOrder.fromFirestore(Map<String, dynamic> parsedJson)
    : orderedBy = parsedJson['orderedBy'],
      orderTimeStamp = parsedJson['orderTimeStamp'].toDate(),
      restaurantUid = parsedJson['restaurantUid'],
      orderId = parsedJson['orderID'],
      menuItemIds = List<String>.from(parsedJson['menuItemIds']),
      menuItemTitles = List.from(
        parsedJson['menuItems'].map((el) => el['menuItemTitle']),
      );
}
