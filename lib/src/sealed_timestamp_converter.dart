import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// A [_SealedTimestampConverter] to convert to/from Dart [DateTime] and Cloud
/// Firestore [Timestamp].
const sealedTimestampConverter = _SealedTimestampConverter();

/// A [_SealedTimestampConverter] to always use [FieldValue.serverTimestamp]
/// when calling toJson.
const alwaysUseServerTimestampSealedTimestampConverter =
    _SealedTimestampConverter(alwaysUseServerTimestamp: true);

class _SealedTimestampConverter
    implements JsonConverter<SealedTimestamp, Object> {
  const _SealedTimestampConverter({this.alwaysUseServerTimestamp = false});

  final bool alwaysUseServerTimestamp;

  @override
  SealedTimestamp fromJson(Object json) {
    final timestamp = json as Timestamp;
    return ClientDateTime(timestamp.toDate());
  }

  @override
  Object toJson(SealedTimestamp sealedTimestamp) {
    if (alwaysUseServerTimestamp) {
      return FieldValue.serverTimestamp();
    }
    return switch (sealedTimestamp) {
      ClientDateTime(clientDateTime: final clientDateTime) =>
        Timestamp.fromDate(clientDateTime),
      ServerTimestamp() => FieldValue.serverTimestamp(),
    };
  }
}

/// A sealed class to handle both Dart [DateTime] class and Cloud Firestore
/// [Timestamp] class.
sealed class SealedTimestamp {
  /// Creates a [SealedTimestamp].
  const SealedTimestamp();

  /// Returns [DateTime] if this is a [ClientDateTime] instance.
  /// If not, always returns null.
  DateTime? get dateTime {
    return switch (this) {
      ClientDateTime(clientDateTime: final clientDateTime) => clientDateTime,
      ServerTimestamp() => null,
    };
  }
}

/// A [SealedTimestamp] extended class to represents Dart [DateTime] field.
class ClientDateTime extends SealedTimestamp {
  /// Creates a [ClientDateTime].
  const ClientDateTime(this.clientDateTime);

  /// Dart [DateTime] field.
  final DateTime clientDateTime;
}

/// A [SealedTimestamp] extended class to automatically set Cloud Firestore
/// [FieldValue.serverTimestamp]
class ServerTimestamp extends SealedTimestamp {
  /// Creates a [ServerTimestamp].
  const ServerTimestamp();
}
