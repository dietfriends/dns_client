import 'package:freezed_annotation/freezed_annotation.dart';

part 'dns_record.g.dart';

part 'dns_record.freezed.dart';

@freezed
abstract class DnsRecord implements _$DnsRecord {
  const DnsRecord._(); // Added constructor
  const factory DnsRecord(
      @JsonKey(name: 'Status') int status,
      bool TC,
      bool RD,
      bool RA,
      bool AD,
      bool CD,
      @JsonKey(name: 'edns_client_subnet') @nullable String ednsClientSubnet,
      @JsonKey(name: 'Answer') @nullable List<Answer> answer,
      @JsonKey(name: 'Comment') @nullable String comment) = _DnsRecord;

  factory DnsRecord.fromJson(Map<String, dynamic> json) =>
      _$DnsRecordFromJson(json);

  // SERVFAIL - Standard DNS response code (32 bit integer).
  bool get isFailure => status == 2;

  // NOERROR - Standard DNS response code (32 bit integer)
  bool get isSuccess => status == 1;
}

@freezed
abstract class Question with _$Question {
  const factory Question(String name, int type) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}

@freezed
abstract class Answer with _$Answer {
  const factory Answer(String name, int type, int TTL, String data) = _Answer;

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  static List<Answer> listFromJson(List<Map<String, dynamic>> input) {
    return input.map((i) => _Answer.fromJson(i)).toList();
  }
}
