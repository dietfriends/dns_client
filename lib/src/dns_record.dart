import 'package:freezed_annotation/freezed_annotation.dart';

part 'dns_record.g.dart';

part 'dns_record.freezed.dart';

/// Exception thrown when a DNS lookup fails.
class DnsLookupException implements Exception {
  /// The hostname that was being looked up.
  final String hostname;

  /// The DNS response status code (if available).
  final int? status;

  /// A human-readable error message.
  final String message;

  DnsLookupException(this.message, {required this.hostname, this.status});

  @override
  String toString() => 'DnsLookupException: $message (hostname: $hostname, status: $status)';
}

/// Exception thrown when the DNS-over-HTTPS request fails.
class DnsHttpException implements Exception {
  /// The HTTP status code returned by the server.
  final int statusCode;

  /// A human-readable error message.
  final String message;

  DnsHttpException(this.message, {required this.statusCode});

  @override
  String toString() => 'DnsHttpException: $message (HTTP $statusCode)';
}

@freezed
class DnsRecord with _$DnsRecord {
  const DnsRecord._(); // Added constructor
  const factory DnsRecord(
      @JsonKey(name: 'Status') int status,
      bool TC,
      bool RD,
      bool RA,
      bool AD,
      bool CD,
      @JsonKey(name: 'edns_client_subnet') String? ednsClientSubnet,
      @JsonKey(name: 'Answer') List<Answer>? answer,
      @JsonKey(name: 'Comment') String? comment) = _DnsRecord;

  factory DnsRecord.fromJson(Map<String, dynamic> json) =>
      _$DnsRecordFromJson(json);

  /// NOERROR - Standard DNS response code (0).
  /// Returns true if the DNS query was successful.
  bool get isSuccess => status == 0;

  /// Returns true if the DNS query failed (any non-zero status).
  /// Includes SERVFAIL (2), NXDOMAIN (3), REFUSED (5), etc.
  bool get isFailure => status != 0;

  /// SERVFAIL - DNS server failed to complete the request (status 2).
  bool get isServerFailure => status == 2;

  /// NXDOMAIN - The domain name does not exist (status 3).
  bool get isNxDomain => status == 3;
}

@freezed
class Question with _$Question {
  const factory Question(String name, int type) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}

@freezed
class Answer with _$Answer {
  const factory Answer(String name, int type, int TTL, String data) = _Answer;

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  static List<Answer> listFromJson(List<Map<String, dynamic>> input) {
    return input.map((i) => _Answer.fromJson(i)).toList();
  }
}
