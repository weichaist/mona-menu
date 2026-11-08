import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mona_diner/main.dart';

// Importing main.dart compiles the whole app, including every plugin's Dart
// code, without starting Firebase.
void main() {
  test('the app widget can be created', () {
    expect(const MyApp(), isA<StatelessWidget>());
  });
}
