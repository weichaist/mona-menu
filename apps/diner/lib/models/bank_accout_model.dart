class UserBankAccount {
  final String? bankName;
  final String? branch;
  final String? accType;
  final String? accNumber;
  final String? accName;

  UserBankAccount({
    this.bankName,
    this.branch,
    this.accType,
    this.accNumber,
    this.accName,
  });

  UserBankAccount.fromFirestore(Map<String, dynamic> parsedJson)
    : bankName = parsedJson['bankName'],
      branch = parsedJson['branch'],
      accType = parsedJson['accType'],
      accNumber = parsedJson['accNumber'],
      accName = parsedJson['accName'];

  Map<String, dynamic> toMap() {
    return {
      'bankName': bankName,
      'branch': branch,
      'accType': accType,
      'accNumber': accNumber,
      'accName': accName,
    };
  }
}
