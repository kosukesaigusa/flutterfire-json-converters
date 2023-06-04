import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

const sealedTimestampConverter = _SealedTimestampConverter();

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

sealed class SealedTimestamp {
  DateTime? get dateTime {
    return switch (this) {
      ClientDateTime(clientDateTime: final clientDateTime) => clientDateTime,
      ServerTimestamp() => null,
    };
  }
}

class ClientDateTime extends SealedTimestamp {
  ClientDateTime(this.clientDateTime);

  final DateTime clientDateTime;
}

class ServerTimestamp extends SealedTimestamp {}
