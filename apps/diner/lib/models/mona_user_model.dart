class MUser {
  final String? uid;
  final String? displayName;
  final String? lastName;
  final String? firstName;
  final String? bio;
  final String? email;
  final String? profilePictureURL;
  final bool? onboarded;

  MUser({
    this.uid,
    this.displayName,
    this.firstName,
    this.lastName,
    this.bio,
    this.email,
    this.profilePictureURL,
    this.onboarded,
  });

  MUser.fromFirestore(Map<String, dynamic> parsedJson)
    : uid = parsedJson['uid'],
      displayName = parsedJson['displayName'],
      firstName = parsedJson['firstName'],
      lastName = parsedJson['lastName'],
      bio = parsedJson['bio'],
      email = parsedJson['email'],
      onboarded = parsedJson['onboarded'] ?? false,
      profilePictureURL = parsedJson['profilePictureURL'] != null
          ? parsedJson['profilePictureURL']['url']
          : null;
}
