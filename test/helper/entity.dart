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

  /// Connect the generated [_$EntityFromJson] function to the `fromJson`
  /// factory.
  factory Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);

  /// The generated code assumes these values exist in JSON.
  final String name;

  @sealedTimestampConverter
  final SealedTimestamp createdAt;

  @alwaysUseServerTimestampSealedTimestampConverter
  final SealedTimestamp updatedAt;

  /// Connect the generated [_$EntityToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$EntityToJson(this);
}
