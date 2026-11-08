import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mona_console/config.dart';

/// A place returned by a text search.
class PlaceSearchResult {
  const PlaceSearchResult({
    required this.placeId,
    this.name,
    this.formattedAddress,
  });

  final String placeId;
  final String? name;
  final String? formattedAddress;

  factory PlaceSearchResult.fromJson(Map<String, dynamic> json) {
    return PlaceSearchResult(
      placeId: json['id'] as String,
      name: (json['displayName'] as Map<String, dynamic>?)?['text'] as String?,
      formattedAddress: json['formattedAddress'] as String?,
    );
  }
}

/// The details the onboarding form imports from a place.
class PlaceDetails {
  const PlaceDetails({this.formattedPhoneNumber, this.lat, this.lng});

  final String? formattedPhoneNumber;
  final double? lat;
  final double? lng;

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>?;
    return PlaceDetails(
      formattedPhoneNumber: json['nationalPhoneNumber'] as String?,
      lat: (location?['latitude'] as num?)?.toDouble(),
      lng: (location?['longitude'] as num?)?.toDouble(),
    );
  }
}

/// Looks up restaurants with the Google Places API (New).
///
/// https://developers.google.com/maps/documentation/places/web-service/op-overview
class PlacesAutoCompleteService {
  PlacesAutoCompleteService({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;
  static const _baseUrl = 'https://places.googleapis.com/v1';

  Map<String, String> _headers(String fieldMask) => {
    'Content-Type': 'application/json',
    'X-Goog-Api-Key': AppConfig.googlePlacesApiKey,
    'X-Goog-FieldMask': fieldMask,
  };

  Future<List<PlaceSearchResult>?> getResponse(
    String query,
    String language,
    String country,
  ) async {
    try {
      final res = await _client.post(
        Uri.parse('$_baseUrl/places:searchText'),
        headers: _headers(
          'places.id,places.displayName,places.formattedAddress',
        ),
        body: jsonEncode({
          'textQuery': query,
          'languageCode': language,
          'regionCode': country,
        }),
      );
      if (res.statusCode != 200) {
        debugPrint('Places text search failed: ${res.statusCode} ${res.body}');
        return null;
      }
      final places =
          (jsonDecode(res.body) as Map<String, dynamic>)['places']
              as List<dynamic>? ??
          [];
      return places
          .map((e) => PlaceSearchResult.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<PlaceDetails?> getPlaceDetails(String placeID) async {
    try {
      final res = await _client.get(
        Uri.parse('$_baseUrl/places/$placeID'),
        headers: _headers('nationalPhoneNumber,location'),
      );
      if (res.statusCode != 200) {
        debugPrint('Place details failed: ${res.statusCode} ${res.body}');
        return null;
      }
      return PlaceDetails.fromJson(
        jsonDecode(res.body) as Map<String, dynamic>,
      );
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
