// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Entity _$EntityFromJson(Map<String, dynamic> json) => Entity(
      name: json['name'] as String,
      createdAt: json['createdAt'] == null
          ? const ServerTimestamp()
          : sealedTimestampConverter.fromJson(json['createdAt'] as Object),
      updatedAt: json['updatedAt'] == null
          ? const ServerTimestamp()
          : alwaysUseServerTimestampSealedTimestampConverter
              .fromJson(json['updatedAt'] as Object),
    );

Map<String, dynamic> _$EntityToJson(Entity instance) => <String, dynamic>{
      'name': instance.name,
      'createdAt': sealedTimestampConverter.toJson(instance.createdAt),
      'updatedAt': alwaysUseServerTimestampSealedTimestampConverter
          .toJson(instance.updatedAt),
    };
