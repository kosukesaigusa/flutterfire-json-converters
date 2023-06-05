import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterfire_json_converters/src/sealed_timestamp_converter.dart';

import 'helper/entity.dart';

void main() {
  group('toJson method', () {
    test('uses server timestamp both createdAt and updatedAt', () {
      final entity = Entity(name: 'foo');
      final json = entity.toJson();

      expect(json['name'], 'foo');
      expect(json['createdAt'], isA<FieldValue>());
      expect(json['updatedAt'], isA<FieldValue>());
    });

    test(
        'uses client date time for createdAt and server timestamp for '
        'updatedAt', () {
      final epoch = DateTime(1970);
      final entity = Entity(name: 'foo', createdAt: ClientDateTime(epoch));
      final json = entity.toJson();

      expect(json['name'], 'foo');
      expect(json['createdAt'], Timestamp.fromDate(epoch));
      expect(json['updatedAt'], isA<FieldValue>());
    });

    test('gives client date time to updatedAt but uses server timestamp', () {
      final epoch = DateTime(1970);
      final entity = Entity(
        name: 'foo',
        createdAt: ClientDateTime(epoch),
        updatedAt: ClientDateTime(epoch),
      );
      final json = entity.toJson();

      expect(json['name'], 'foo');
      expect(json['createdAt'], Timestamp.fromDate(epoch));
      expect(json['updatedAt'], isA<FieldValue>());
    });
  });
}
