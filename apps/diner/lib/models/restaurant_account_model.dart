import 'package:mona_diner/models/business_hour_model.dart';

class RestaurantAccount {
  final String? name;
  final String? address;
  final double? lat;
  final double? lng;
  final String? genre;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? bgImageUrl;
  final String? about;
  final List<BusinessHour>? businessHours;
  final bool eatIn;
  final bool takeout;
  final bool oneSetMenu;
  final int? serviceCharge;
  final List<String>? tableNumbers;
  final String? uid;
  final List<String>? lunchMenuCategoryList;
  final List<String>? dinnerMenuCategoryList;

  RestaurantAccount({
    this.name,
    this.address,
    this.lat,
    this.lng,
    this.genre,
    this.phoneNumber,
    this.profileImageUrl,
    this.bgImageUrl,
    this.about,
    this.businessHours,
    this.serviceCharge,
    this.takeout = false,
    this.eatIn = true,
    this.oneSetMenu = false,
    this.tableNumbers,
    this.uid,
    this.lunchMenuCategoryList,
    this.dinnerMenuCategoryList,
  });

  RestaurantAccount.fromFirestore(Map<String, dynamic> parsedJson)
    : name = parsedJson['name'],
      address = parsedJson['address'],
      lat = parsedJson['_geoloc'] != null ? parsedJson['_geoloc']['lat'] : null,
      lng = parsedJson['_geoloc'] != null ? parsedJson['_geoloc']['lng'] : null,
      genre = parsedJson['genre'],
      phoneNumber = parsedJson['phoneNumber'],
      about = parsedJson['about'],
      businessHours = parsedJson['businessHours'] != null
          ? List.from(
              parsedJson['businessHours'],
            ).map((e) => BusinessHour.fromFirestore(e)).toList()
          : <BusinessHour>[],
      profileImageUrl = parsedJson['profileImageRef'] != null
          ? parsedJson['profileImageRef']['url']
          : '',
      bgImageUrl = parsedJson['bgImageRef'] != null
          ? parsedJson['bgImageRef']['url']
          : '',
      serviceCharge = parsedJson['serviceCharge'] as int,
      eatIn = parsedJson['eatIn'] ?? true,
      takeout = parsedJson['takeout'] ?? false,
      oneSetMenu = parsedJson['oneSetMenu'] ?? false,
      tableNumbers = parsedJson['tableNumbers'] != null
          ? List.from(parsedJson['tableNumbers'])
          : [],
      lunchMenuCategoryList = parsedJson['lunchMenuCategoryList'] != null
          ? List.from(parsedJson['lunchMenuCategoryList'])
          : [],
      dinnerMenuCategoryList = parsedJson['dinnerMenuCategoryList'] != null
          ? List.from(parsedJson['dinnerMenuCategoryList'])
          : [],
      uid = parsedJson['uid'];
}
