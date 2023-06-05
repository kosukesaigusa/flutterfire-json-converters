import 'package:flutterfire_json_converters/flutterfire_json_converters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

@JsonSerializable()
class Entity {
  Entity({
    required this.name,
    this.createdAt = const ServerTimestamp(),
    this.updatedAt = const ServerTimestamp(),
  });

  factory Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);

  final String name;

  // Handle both Dart's `DateTime` and Cloud Firestore's `Timestamp` types.
  @sealedTimestampConverter
  final SealedTimestamp createdAt;

  // Handle both Dart's `DateTime` and Cloud Firestore's `Timestamp` types, and
  // always use `FieldValue.serverTimestamp()` when creating/updating a document.
  @alwaysUseServerTimestampSealedTimestampConverter
  final SealedTimestamp updatedAt;

  Map<String, dynamic> toJson() => _$EntityToJson(this);
}
