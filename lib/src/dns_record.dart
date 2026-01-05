// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'dns_record.freezed.dart';
part 'dns_record.g.dart';

/// Represents a DNS response record returned by a server.
@freezed
abstract class DnsRecord with _$DnsRecord {
  const DnsRecord._();

  /// Creates a DNS record from the JSON response.
  ///
  /// Fields correspond to the standard DNS over HTTPS (DoH) JSON format.
  const factory DnsRecord({
    /// DNS response code (e.g., 1 = NOERROR, 2 = SERVFAIL)
    @JsonKey(name: 'Status') required int status,

    /// Truncated flag – true if the response was too large for a UDP packet
    required bool TC,

    /// Recursion desired – true if the client requested recursive resolution
    required bool RD,

    /// Recursion available – true if the server supports recursion
    required bool RA,

    /// Authenticated data – true if DNSSEC validation passed
    required bool AD,

    /// Checking disabled – true if DNSSEC checks were disabled by the client
    required bool CD,

    /// Client subnet information (EDNS)
    @JsonKey(name: 'edns_client_subnet') String? ednsClientSubnet,

    /// List of DNS answers returned
    @JsonKey(name: 'Answer') List<Answer>? answer,

    /// Optional comment or metadata
    @JsonKey(name: 'Comment') String? comment,
  }) = _DnsRecord;

  /// Creates a [DnsRecord] from a JSON map.
  factory DnsRecord.fromJson(Map<String, dynamic> json) =>
      _$DnsRecordFromJson(json);

  /// Returns true if the response code is SERVFAIL.
  bool get isFailure => status == 2;

  /// Returns true if the response code is NOERROR.
  bool get isSuccess => status == 1;
}

/// Represents a DNS question in a query.
@freezed
abstract class Question with _$Question {
  /// Creates a DNS question with [name] and [type].
  const factory Question(String name, int type) = _Question;

  /// Creates a [Question] from a JSON map.
  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}

/// Represents a DNS answer returned in a response.
@freezed
abstract class Answer with _$Answer {
  /// Creates a DNS answer with optional fields depending on the record type.
  const factory Answer(
    /// Name of the resource record
    String name,

    /// Numeric type code of the DNS record
    int type,

    /// Time to live (TTL) in seconds
    int TTL,

    /// Data contained in the record (IP, CNAME, TXT, etc.)
    String data,
  ) = _Answer;

  /// Creates an [Answer] from a JSON map.
  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);
}

extension DnsAnswerExtension on Answer {
  /// Converts the numeric DNS type code to the enum
  DnsRecordType get recordType => DnsRecordType.fromInt(type);

  FutureOr<InternetAddress> get asInternetAddress {
    var d = data.trim();
    var parts = d.split(RegExp(r'\s+'));

    var a = parts.last;
    while (a.startsWith('.')) {
      a = a.substring(1);
    }
    while (a.endsWith('.')) {
      a = a.substring(0, a.length - 1);
    }

    if (a.isEmpty) {
      throw StateError("Empty address!");
    }

    return InternetAddress.tryParse(a) ??
        InternetAddress.lookup(a).then((l) => l.first);
  }

  Future<InternetAddress> get asInternetAddressAsync {
    var a = asInternetAddress;
    return a is Future<InternetAddress> ? a : Future.value(a);
  }
}

/// Represents the type of a DNS record.
///
/// Each type has a numeric code (`typeValue`), a string label (`value`),
/// and a human-readable description (`description`).
enum DnsRecordType {
  A(1, 'A', 'IPv4 address record'),
  AAAA(28, 'AAAA', 'IPv6 address record'),
  MX(15, 'MX', 'Mail exchange record'),
  CNAME(5, 'CNAME', 'Canonical name (alias) record'),
  TXT(16, 'TXT', 'Text record, often for SPF/DKIM/etc.'),
  NS(2, 'NS', 'Authoritative name server record'),
  SOA(6, 'SOA', 'Start of authority record'),
  HTTPS(65, 'HTTPS', 'HTTPS service binding record (SVCB)'),
  CAA(257, 'CAA', 'Certificate Authority Authorization record'),
  ANY(255, 'ANY', 'Wildcard type to query all records');

  final int typeValue;
  final String value;
  final String description;

  const DnsRecordType(this.typeValue, this.value, this.description);

  /// Get enum from numeric DNS type code
  static DnsRecordType fromInt(int type) {
    for (var recordType in DnsRecordType.values) {
      if (recordType.typeValue == type) return recordType;
    }
    throw ArgumentError('Unknown DNS record type: $type');
  }
}
