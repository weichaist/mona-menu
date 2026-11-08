class RepeaterApplication {
  final String? appliedBy;
  final DateTime? appliedAt;
  final String? status;

  RepeaterApplication({this.appliedBy, this.appliedAt, this.status});

  RepeaterApplication.fromFirestore(Map<String, dynamic> parsedJson)
    : appliedBy = parsedJson['uid'],
      appliedAt = parsedJson['timestamp'].toDate(),
      status = parsedJson['status'];
}
