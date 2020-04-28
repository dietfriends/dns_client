// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'dns_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
DnsRecord _$DnsRecordFromJson(Map<String, dynamic> json) {
  return _DnsRecord.fromJson(json);
}

class _$DnsRecordTearOff {
  const _$DnsRecordTearOff();

  _DnsRecord call(
      @JsonKey(name: 'Status') int status,
      bool TC,
      bool RD,
      bool RA,
      bool AD,
      bool CD,
      @JsonKey(name: 'edns_client_subnet') @nullable String ednsClientSubnet,
      @JsonKey(name: 'Answer') @nullable List<Answer> answer,
      @JsonKey(name: 'Comment') @nullable String comment) {
    return _DnsRecord(
      status,
      TC,
      RD,
      RA,
      AD,
      CD,
      ednsClientSubnet,
      answer,
      comment,
    );
  }
}

// ignore: unused_element
const $DnsRecord = _$DnsRecordTearOff();

mixin _$DnsRecord {
  @JsonKey(name: 'Status')
  int get status;
  bool get TC;
  bool get RD;
  bool get RA;
  bool get AD;
  bool get CD;
  @JsonKey(name: 'edns_client_subnet')
  @nullable
  String get ednsClientSubnet;
  @JsonKey(name: 'Answer')
  @nullable
  List<Answer> get answer;
  @JsonKey(name: 'Comment')
  @nullable
  String get comment;

  Map<String, dynamic> toJson();
  $DnsRecordCopyWith<DnsRecord> get copyWith;
}

abstract class $DnsRecordCopyWith<$Res> {
  factory $DnsRecordCopyWith(DnsRecord value, $Res Function(DnsRecord) then) =
      _$DnsRecordCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: 'Status') int status,
      bool TC,
      bool RD,
      bool RA,
      bool AD,
      bool CD,
      @JsonKey(name: 'edns_client_subnet') @nullable String ednsClientSubnet,
      @JsonKey(name: 'Answer') @nullable List<Answer> answer,
      @JsonKey(name: 'Comment') @nullable String comment});
}

class _$DnsRecordCopyWithImpl<$Res> implements $DnsRecordCopyWith<$Res> {
  _$DnsRecordCopyWithImpl(this._value, this._then);

  final DnsRecord _value;
  // ignore: unused_field
  final $Res Function(DnsRecord) _then;

  @override
  $Res call({
    Object status = freezed,
    Object TC = freezed,
    Object RD = freezed,
    Object RA = freezed,
    Object AD = freezed,
    Object CD = freezed,
    Object ednsClientSubnet = freezed,
    Object answer = freezed,
    Object comment = freezed,
  }) {
    return _then(_value.copyWith(
      status: status == freezed ? _value.status : status as int,
      TC: TC == freezed ? _value.TC : TC as bool,
      RD: RD == freezed ? _value.RD : RD as bool,
      RA: RA == freezed ? _value.RA : RA as bool,
      AD: AD == freezed ? _value.AD : AD as bool,
      CD: CD == freezed ? _value.CD : CD as bool,
      ednsClientSubnet: ednsClientSubnet == freezed
          ? _value.ednsClientSubnet
          : ednsClientSubnet as String,
      answer: answer == freezed ? _value.answer : answer as List<Answer>,
      comment: comment == freezed ? _value.comment : comment as String,
    ));
  }
}

abstract class _$DnsRecordCopyWith<$Res> implements $DnsRecordCopyWith<$Res> {
  factory _$DnsRecordCopyWith(
          _DnsRecord value, $Res Function(_DnsRecord) then) =
      __$DnsRecordCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: 'Status') int status,
      bool TC,
      bool RD,
      bool RA,
      bool AD,
      bool CD,
      @JsonKey(name: 'edns_client_subnet') @nullable String ednsClientSubnet,
      @JsonKey(name: 'Answer') @nullable List<Answer> answer,
      @JsonKey(name: 'Comment') @nullable String comment});
}

class __$DnsRecordCopyWithImpl<$Res> extends _$DnsRecordCopyWithImpl<$Res>
    implements _$DnsRecordCopyWith<$Res> {
  __$DnsRecordCopyWithImpl(_DnsRecord _value, $Res Function(_DnsRecord) _then)
      : super(_value, (v) => _then(v as _DnsRecord));

  @override
  _DnsRecord get _value => super._value as _DnsRecord;

  @override
  $Res call({
    Object status = freezed,
    Object TC = freezed,
    Object RD = freezed,
    Object RA = freezed,
    Object AD = freezed,
    Object CD = freezed,
    Object ednsClientSubnet = freezed,
    Object answer = freezed,
    Object comment = freezed,
  }) {
    return _then(_DnsRecord(
      status == freezed ? _value.status : status as int,
      TC == freezed ? _value.TC : TC as bool,
      RD == freezed ? _value.RD : RD as bool,
      RA == freezed ? _value.RA : RA as bool,
      AD == freezed ? _value.AD : AD as bool,
      CD == freezed ? _value.CD : CD as bool,
      ednsClientSubnet == freezed
          ? _value.ednsClientSubnet
          : ednsClientSubnet as String,
      answer == freezed ? _value.answer : answer as List<Answer>,
      comment == freezed ? _value.comment : comment as String,
    ));
  }
}

@JsonSerializable()
class _$_DnsRecord extends _DnsRecord {
  const _$_DnsRecord(
      @JsonKey(name: 'Status') this.status,
      this.TC,
      this.RD,
      this.RA,
      this.AD,
      this.CD,
      @JsonKey(name: 'edns_client_subnet') @nullable this.ednsClientSubnet,
      @JsonKey(name: 'Answer') @nullable this.answer,
      @JsonKey(name: 'Comment') @nullable this.comment)
      : assert(status != null),
        assert(TC != null),
        assert(RD != null),
        assert(RA != null),
        assert(AD != null),
        assert(CD != null),
        super._();

  factory _$_DnsRecord.fromJson(Map<String, dynamic> json) =>
      _$_$_DnsRecordFromJson(json);

  @override
  @JsonKey(name: 'Status')
  final int status;
  @override
  final bool TC;
  @override
  final bool RD;
  @override
  final bool RA;
  @override
  final bool AD;
  @override
  final bool CD;
  @override
  @JsonKey(name: 'edns_client_subnet')
  @nullable
  final String ednsClientSubnet;
  @override
  @JsonKey(name: 'Answer')
  @nullable
  final List<Answer> answer;
  @override
  @JsonKey(name: 'Comment')
  @nullable
  final String comment;

  @override
  String toString() {
    return 'DnsRecord(status: $status, TC: $TC, RD: $RD, RA: $RA, AD: $AD, CD: $CD, ednsClientSubnet: $ednsClientSubnet, answer: $answer, comment: $comment)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _DnsRecord &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.TC, TC) ||
                const DeepCollectionEquality().equals(other.TC, TC)) &&
            (identical(other.RD, RD) ||
                const DeepCollectionEquality().equals(other.RD, RD)) &&
            (identical(other.RA, RA) ||
                const DeepCollectionEquality().equals(other.RA, RA)) &&
            (identical(other.AD, AD) ||
                const DeepCollectionEquality().equals(other.AD, AD)) &&
            (identical(other.CD, CD) ||
                const DeepCollectionEquality().equals(other.CD, CD)) &&
            (identical(other.ednsClientSubnet, ednsClientSubnet) ||
                const DeepCollectionEquality()
                    .equals(other.ednsClientSubnet, ednsClientSubnet)) &&
            (identical(other.answer, answer) ||
                const DeepCollectionEquality().equals(other.answer, answer)) &&
            (identical(other.comment, comment) ||
                const DeepCollectionEquality().equals(other.comment, comment)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(TC) ^
      const DeepCollectionEquality().hash(RD) ^
      const DeepCollectionEquality().hash(RA) ^
      const DeepCollectionEquality().hash(AD) ^
      const DeepCollectionEquality().hash(CD) ^
      const DeepCollectionEquality().hash(ednsClientSubnet) ^
      const DeepCollectionEquality().hash(answer) ^
      const DeepCollectionEquality().hash(comment);

  @override
  _$DnsRecordCopyWith<_DnsRecord> get copyWith =>
      __$DnsRecordCopyWithImpl<_DnsRecord>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_DnsRecordToJson(this);
  }
}

abstract class _DnsRecord extends DnsRecord {
  const _DnsRecord._() : super._();
  const factory _DnsRecord(
      @JsonKey(name: 'Status') int status,
      bool TC,
      bool RD,
      bool RA,
      bool AD,
      bool CD,
      @JsonKey(name: 'edns_client_subnet') @nullable String ednsClientSubnet,
      @JsonKey(name: 'Answer') @nullable List<Answer> answer,
      @JsonKey(name: 'Comment') @nullable String comment) = _$_DnsRecord;

  factory _DnsRecord.fromJson(Map<String, dynamic> json) =
      _$_DnsRecord.fromJson;

  @override
  @JsonKey(name: 'Status')
  int get status;
  @override
  bool get TC;
  @override
  bool get RD;
  @override
  bool get RA;
  @override
  bool get AD;
  @override
  bool get CD;
  @override
  @JsonKey(name: 'edns_client_subnet')
  @nullable
  String get ednsClientSubnet;
  @override
  @JsonKey(name: 'Answer')
  @nullable
  List<Answer> get answer;
  @override
  @JsonKey(name: 'Comment')
  @nullable
  String get comment;
  @override
  _$DnsRecordCopyWith<_DnsRecord> get copyWith;
}

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return _Question.fromJson(json);
}

class _$QuestionTearOff {
  const _$QuestionTearOff();

  _Question call(String name, int type) {
    return _Question(
      name,
      type,
    );
  }
}

// ignore: unused_element
const $Question = _$QuestionTearOff();

mixin _$Question {
  String get name;
  int get type;

  Map<String, dynamic> toJson();
  $QuestionCopyWith<Question> get copyWith;
}

abstract class $QuestionCopyWith<$Res> {
  factory $QuestionCopyWith(Question value, $Res Function(Question) then) =
      _$QuestionCopyWithImpl<$Res>;
  $Res call({String name, int type});
}

class _$QuestionCopyWithImpl<$Res> implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._value, this._then);

  final Question _value;
  // ignore: unused_field
  final $Res Function(Question) _then;

  @override
  $Res call({
    Object name = freezed,
    Object type = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as int,
    ));
  }
}

abstract class _$QuestionCopyWith<$Res> implements $QuestionCopyWith<$Res> {
  factory _$QuestionCopyWith(_Question value, $Res Function(_Question) then) =
      __$QuestionCopyWithImpl<$Res>;
  @override
  $Res call({String name, int type});
}

class __$QuestionCopyWithImpl<$Res> extends _$QuestionCopyWithImpl<$Res>
    implements _$QuestionCopyWith<$Res> {
  __$QuestionCopyWithImpl(_Question _value, $Res Function(_Question) _then)
      : super(_value, (v) => _then(v as _Question));

  @override
  _Question get _value => super._value as _Question;

  @override
  $Res call({
    Object name = freezed,
    Object type = freezed,
  }) {
    return _then(_Question(
      name == freezed ? _value.name : name as String,
      type == freezed ? _value.type : type as int,
    ));
  }
}

@JsonSerializable()
class _$_Question implements _Question {
  const _$_Question(this.name, this.type)
      : assert(name != null),
        assert(type != null);

  factory _$_Question.fromJson(Map<String, dynamic> json) =>
      _$_$_QuestionFromJson(json);

  @override
  final String name;
  @override
  final int type;

  @override
  String toString() {
    return 'Question(name: $name, type: $type)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Question &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(type);

  @override
  _$QuestionCopyWith<_Question> get copyWith =>
      __$QuestionCopyWithImpl<_Question>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_QuestionToJson(this);
  }
}

abstract class _Question implements Question {
  const factory _Question(String name, int type) = _$_Question;

  factory _Question.fromJson(Map<String, dynamic> json) = _$_Question.fromJson;

  @override
  String get name;
  @override
  int get type;
  @override
  _$QuestionCopyWith<_Question> get copyWith;
}

Answer _$AnswerFromJson(Map<String, dynamic> json) {
  return _Answer.fromJson(json);
}

class _$AnswerTearOff {
  const _$AnswerTearOff();

  _Answer call(String name, int type, int TTL, String data) {
    return _Answer(
      name,
      type,
      TTL,
      data,
    );
  }
}

// ignore: unused_element
const $Answer = _$AnswerTearOff();

mixin _$Answer {
  String get name;
  int get type;
  int get TTL;
  String get data;

  Map<String, dynamic> toJson();
  $AnswerCopyWith<Answer> get copyWith;
}

abstract class $AnswerCopyWith<$Res> {
  factory $AnswerCopyWith(Answer value, $Res Function(Answer) then) =
      _$AnswerCopyWithImpl<$Res>;
  $Res call({String name, int type, int TTL, String data});
}

class _$AnswerCopyWithImpl<$Res> implements $AnswerCopyWith<$Res> {
  _$AnswerCopyWithImpl(this._value, this._then);

  final Answer _value;
  // ignore: unused_field
  final $Res Function(Answer) _then;

  @override
  $Res call({
    Object name = freezed,
    Object type = freezed,
    Object TTL = freezed,
    Object data = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as int,
      TTL: TTL == freezed ? _value.TTL : TTL as int,
      data: data == freezed ? _value.data : data as String,
    ));
  }
}

abstract class _$AnswerCopyWith<$Res> implements $AnswerCopyWith<$Res> {
  factory _$AnswerCopyWith(_Answer value, $Res Function(_Answer) then) =
      __$AnswerCopyWithImpl<$Res>;
  @override
  $Res call({String name, int type, int TTL, String data});
}

class __$AnswerCopyWithImpl<$Res> extends _$AnswerCopyWithImpl<$Res>
    implements _$AnswerCopyWith<$Res> {
  __$AnswerCopyWithImpl(_Answer _value, $Res Function(_Answer) _then)
      : super(_value, (v) => _then(v as _Answer));

  @override
  _Answer get _value => super._value as _Answer;

  @override
  $Res call({
    Object name = freezed,
    Object type = freezed,
    Object TTL = freezed,
    Object data = freezed,
  }) {
    return _then(_Answer(
      name == freezed ? _value.name : name as String,
      type == freezed ? _value.type : type as int,
      TTL == freezed ? _value.TTL : TTL as int,
      data == freezed ? _value.data : data as String,
    ));
  }
}

@JsonSerializable()
class _$_Answer implements _Answer {
  const _$_Answer(this.name, this.type, this.TTL, this.data)
      : assert(name != null),
        assert(type != null),
        assert(TTL != null),
        assert(data != null);

  factory _$_Answer.fromJson(Map<String, dynamic> json) =>
      _$_$_AnswerFromJson(json);

  @override
  final String name;
  @override
  final int type;
  @override
  final int TTL;
  @override
  final String data;

  @override
  String toString() {
    return 'Answer(name: $name, type: $type, TTL: $TTL, data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Answer &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.TTL, TTL) ||
                const DeepCollectionEquality().equals(other.TTL, TTL)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(TTL) ^
      const DeepCollectionEquality().hash(data);

  @override
  _$AnswerCopyWith<_Answer> get copyWith =>
      __$AnswerCopyWithImpl<_Answer>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_AnswerToJson(this);
  }
}

abstract class _Answer implements Answer {
  const factory _Answer(String name, int type, int TTL, String data) =
      _$_Answer;

  factory _Answer.fromJson(Map<String, dynamic> json) = _$_Answer.fromJson;

  @override
  String get name;
  @override
  int get type;
  @override
  int get TTL;
  @override
  String get data;
  @override
  _$AnswerCopyWith<_Answer> get copyWith;
}
