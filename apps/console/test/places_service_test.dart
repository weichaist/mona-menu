import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mona_console/APIs/google_places_services.dart';

void main() {
  test('text search sends the field mask and parses places', () async {
    late http.Request sent;
    final service = PlacesAutoCompleteService(
      client: MockClient((request) async {
        sent = request;
        return http.Response(
          jsonEncode({
            'places': [
              {
                'id': 'place-1',
                'displayName': {'text': 'Sample Bistro', 'languageCode': 'ja'},
                'formattedAddress': '1-2-3 Example, Tokyo',
              },
            ],
          }),
          200,
        );
      }),
    );

    final results = await service.getResponse('bistro', 'ja', 'JP');

    expect(sent.url.path, '/v1/places:searchText');
    expect(
      sent.headers['X-Goog-FieldMask'],
      'places.id,places.displayName,places.formattedAddress',
    );
    expect(jsonDecode(sent.body), {
      'textQuery': 'bistro',
      'languageCode': 'ja',
      'regionCode': 'JP',
    });
    expect(results, hasLength(1));
    expect(results!.single.placeId, 'place-1');
    expect(results.single.name, 'Sample Bistro');
    expect(results.single.formattedAddress, '1-2-3 Example, Tokyo');
  });

  test('place details returns the phone number and location', () async {
    final service = PlacesAutoCompleteService(
      client: MockClient((request) async {
        expect(request.url.path, '/v1/places/place-1');
        return http.Response(
          jsonEncode({
            'nationalPhoneNumber': '03-0000-0000',
            'location': {'latitude': 35.68, 'longitude': 139.76},
          }),
          200,
        );
      }),
    );

    final details = await service.getPlaceDetails('place-1');

    expect(details!.formattedPhoneNumber, '03-0000-0000');
    expect(details.lat, 35.68);
    expect(details.lng, 139.76);
  });

  test('returns null when the API answers with an error', () async {
    final service = PlacesAutoCompleteService(
      client: MockClient((_) async => http.Response('{"error":{}}', 403)),
    );
    expect(await service.getResponse('x', 'ja', 'JP'), isNull);
    expect(await service.getPlaceDetails('x'), isNull);
  });
}
