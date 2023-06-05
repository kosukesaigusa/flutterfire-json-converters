import 'package:flutterfire_json_converters/flutterfire_json_converters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'main.g.dart';

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

void main() {
  final epoch = DateTime(1970);
  final entity = Entity(name: 'foo', createdAt: ClientDateTime(epoch));
  final json = entity.toJson();

  print(json['name']); // 'foo'
  print(json['createdAt']); // Timestamp(seconds=0, nanoseconds=0)
  print(json['updatedAt']); // FieldValue(Instance of 'MethodChannelFieldValue')
}
