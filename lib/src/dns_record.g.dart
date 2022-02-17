// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dns_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DnsRecord _$$_DnsRecordFromJson(Map<String, dynamic> json) => _$_DnsRecord(
      json['Status'] as int,
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

Map<String, dynamic> _$$_DnsRecordToJson(_$_DnsRecord instance) =>
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

_$_Question _$$_QuestionFromJson(Map<String, dynamic> json) => _$_Question(
      json['name'] as String,
      json['type'] as int,
    );

Map<String, dynamic> _$$_QuestionToJson(_$_Question instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
    };

_$_Answer _$$_AnswerFromJson(Map<String, dynamic> json) => _$_Answer(
      json['name'] as String,
      json['type'] as int,
      json['TTL'] as int,
      json['data'] as String,
    );

Map<String, dynamic> _$$_AnswerToJson(_$_Answer instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'TTL': instance.TTL,
      'data': instance.data,
    };
