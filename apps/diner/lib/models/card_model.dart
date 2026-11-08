class UserCreditCard {
  final String? last4;
  final String? stripePaymentMethodId;
  final int? expiryYear;
  final int? expiryMonth;
  final String? cardBrand;

  UserCreditCard({
    this.last4,
    this.stripePaymentMethodId,
    this.expiryYear,
    this.expiryMonth,
    this.cardBrand,
  });

  UserCreditCard.fromFirestore(Map<String, dynamic> parsedJson)
    : last4 = parsedJson['last4'],
      stripePaymentMethodId = parsedJson['stripePaymentMethodId'],
      expiryYear = parsedJson['expiryYear'] as int,
      expiryMonth = parsedJson['expiryMonth'] as int,
      cardBrand = parsedJson['cardBrand'];

  Map<String, dynamic> toMap() {
    return {'last4': last4, 'cardBrand': cardBrand};
  }
}
