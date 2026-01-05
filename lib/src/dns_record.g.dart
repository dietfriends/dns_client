// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dns_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DnsRecord _$DnsRecordFromJson(Map<String, dynamic> json) => _DnsRecord(
      (json['Status'] as num).toInt(),
      json['TC'] as bool,
      json['RD'] as bool,
      json['RA'] as bool,
      json['AD'] as bool,
      json['CD'] as bool,
      json['edns_client_subnet'] as String?,
      (json['Answer'] as List<dynamic>?)
          ?.map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['Comment'] as String?,
    );

Map<String, dynamic> _$DnsRecordToJson(_DnsRecord instance) =>
    <String, dynamic>{
      'Status': instance.status,
      'TC': instance.TC,
      'RD': instance.RD,
      'RA': instance.RA,
      'AD': instance.AD,
      'CD': instance.CD,
      'edns_client_subnet': instance.ednsClientSubnet,
      'Answer': instance.answer,
      'Comment': instance.comment,
    };

_Question _$QuestionFromJson(Map<String, dynamic> json) => _Question(
      json['name'] as String,
      (json['type'] as num).toInt(),
    );

Map<String, dynamic> _$QuestionToJson(_Question instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
    };

_Answer _$AnswerFromJson(Map<String, dynamic> json) => _Answer(
      json['name'] as String,
      (json['type'] as num).toInt(),
      (json['TTL'] as num).toInt(),
      json['data'] as String,
    );

Map<String, dynamic> _$AnswerToJson(_Answer instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'TTL': instance.TTL,
      'data': instance.data,
    };
