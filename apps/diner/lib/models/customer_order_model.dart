class CustomerOrder {
  final String? orderedBy;
  final String? restaurantUid;
  final DateTime? orderTimeStamp;
  final List<String>? menuItemTitles;
  final List<String>? menuItemIds;
  final String? orderId;
  final String? tableId;
  final String? status;
  final double? totalPrice;
  final String? paymentMethod;

  CustomerOrder({
    this.orderedBy,
    this.restaurantUid,
    this.orderTimeStamp,
    this.menuItemTitles,
    this.menuItemIds,
    this.orderId,
    this.tableId,
    this.status,
    this.totalPrice,
    this.paymentMethod,
  });

  CustomerOrder.fromFirestore(Map<String, dynamic> parsedJson)
    : orderedBy = parsedJson['orderedBy'],
      orderTimeStamp = parsedJson['orderTimeStamp'].toDate(),
      restaurantUid = parsedJson['restaurantUid'],
      orderId = parsedJson['orderID'],
      tableId = parsedJson['tableNumber'],
      status = parsedJson['orderStatus'],
      totalPrice = double.parse(parsedJson['totalPrice'].toString()),
      paymentMethod = parsedJson['paymentMethod'],
      menuItemIds = List<String>.from(parsedJson['menuItemIds']),
      menuItemTitles = List.from(
        parsedJson['menuItems'].map((el) => el['menuItemTitle']),
      );
}
