class AccBasicInfo {
  final String? name;
  final String? address;
  final double? lat;
  final double? lng;
  final String? genre;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? bgImageUrl;
  final String? about;
  final bool? onboardingCompleted;

  AccBasicInfo({
    this.name,
    this.address,
    this.lat,
    this.lng,
    this.genre,
    this.phoneNumber,
    this.profileImageUrl,
    this.bgImageUrl,
    this.about,
    this.onboardingCompleted,
  });

  AccBasicInfo.fromFirestore(Map<String, dynamic> parsedJson)
    : name = parsedJson['name'],
      address = parsedJson['address'],
      lat = parsedJson['_geoloc'] != null ? parsedJson['_geoloc']['lat'] : null,
      lng = parsedJson['_geoloc'] != null ? parsedJson['_geoloc']['lng'] : null,
      genre = parsedJson['genre'],
      phoneNumber = parsedJson['phoneNumber'],
      about = parsedJson['about'],
      onboardingCompleted = parsedJson['onboardingCompleted'] ?? false,
      profileImageUrl = parsedJson['profileImageRef'] != null
          ? parsedJson['profileImageRef']['url']
          : '',
      bgImageUrl = parsedJson['bgImageRef'] != null
          ? parsedJson['bgImageRef']['url']
          : '';
}
