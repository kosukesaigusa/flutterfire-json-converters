# flutterfire_json_converters

flutterfire_json_converters package supplies some useful json_converters when you use [json_serializable](https://pub.dev/packages/json_serializable) or [freezed](https://pub.dev/packages/freezed) for your FlutterFire apps.

## How to use

### Requirements

This package uses Dart 3 features, so you need to use compatible Dart (Flutter) SDK.

```yaml
environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.10.0'
```

### Install

In order to use flutterfire_json_converters with [json_serializable](https://pub.dev/packages/json_serializable) or [freezed](https://pub.dev/packages/freezed), you need to install the following packages.

```sh
# For code generation
flutter pub add --dev build_runner

# If you use freezed
flutter pub add freezed_annotation
flutter pub add --dev freezed

# if you use json_serializable
flutter pub add json_serializable
flutter pub add json_annotation
flutter pub add --dev json_serializable
```

### sealedTimestampConverter

When dealing with Cloud Firestore's `Timestamp` field, you may encounter the following scenarios:

- You want to manipulate the field as a Dart `DateTime` type.
- During the creation or updating of Cloud Firestore documents, you may want to automatically set certain fields (e.g., `updatedAt`) to `FieldValue.serverTimestamp()`.
- For other fields (e.g., `createdAt`), you might sometimes prefer to specify a client-side DateTime and save it to a Cloud Firestore document, while at other times you might want to automatically set it to `FieldValue.serverTimestamp()`.

For such scenarios, you can define `DateTime`/`Timestamp` fields as `SealedTimestamp` type with `@sealedTimestampConverter`/`@alwaysUseServerTimestampSealedTimestampConverter` json_converter annotations like below:

```dart
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
```

When you want to get `DateTime` value of their fields on Dart client-side, you can call `SealedTimestamp.dateTime`.

```dart
final epoch = DateTime(1970);
final entity = Entity(name: 'foo', createdAt: ClientDateTime(epoch));

print(entity.name); // 'foo'
print(entity.createdAt.dateTime) // 1970-01-01 00:00:00.000
print(entity.updatedAt.dateTime) // null

final json = entity.toJson();

print(json['name']); // 'foo'
print(json['createdAt']); // Timestamp(seconds=0, nanoseconds=0)
print(json['updatedAt']); // FieldValue(Instance of 'MethodChannelFieldValue')
```

## Acknowledgements

This package is developed with reference to:

<https://pub.dev/packages/json_converter_helper>

We would like to express our gratitude for their valuable contributions.
