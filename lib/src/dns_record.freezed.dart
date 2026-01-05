// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dns_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DnsRecord {
  @JsonKey(name: 'Status')
  int get status;
  bool get TC;
  bool get RD;
  bool get RA;
  bool get AD;
  bool get CD;
  @JsonKey(name: 'edns_client_subnet')
  String? get ednsClientSubnet;
  @JsonKey(name: 'Answer')
  List<Answer>? get answer;
  @JsonKey(name: 'Comment')
  String? get comment;

  /// Create a copy of DnsRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DnsRecordCopyWith<DnsRecord> get copyWith =>
      _$DnsRecordCopyWithImpl<DnsRecord>(this as DnsRecord, _$identity);

  /// Serializes this DnsRecord to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DnsRecord &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.TC, TC) || other.TC == TC) &&
            (identical(other.RD, RD) || other.RD == RD) &&
            (identical(other.RA, RA) || other.RA == RA) &&
            (identical(other.AD, AD) || other.AD == AD) &&
            (identical(other.CD, CD) || other.CD == CD) &&
            (identical(other.ednsClientSubnet, ednsClientSubnet) ||
                other.ednsClientSubnet == ednsClientSubnet) &&
            const DeepCollectionEquality().equals(other.answer, answer) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, TC, RD, RA, AD, CD,
      ednsClientSubnet, const DeepCollectionEquality().hash(answer), comment);

  @override
  String toString() {
    return 'DnsRecord(status: $status, TC: $TC, RD: $RD, RA: $RA, AD: $AD, CD: $CD, ednsClientSubnet: $ednsClientSubnet, answer: $answer, comment: $comment)';
  }
}

/// @nodoc
abstract mixin class $DnsRecordCopyWith<$Res> {
  factory $DnsRecordCopyWith(DnsRecord value, $Res Function(DnsRecord) _then) =
      _$DnsRecordCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'Status') int status,
      bool TC,
      bool RD,
      bool RA,
      bool AD,
      bool CD,
      @JsonKey(name: 'edns_client_subnet') String? ednsClientSubnet,
      @JsonKey(name: 'Answer') List<Answer>? answer,
      @JsonKey(name: 'Comment') String? comment});
}

/// @nodoc
class _$DnsRecordCopyWithImpl<$Res> implements $DnsRecordCopyWith<$Res> {
  _$DnsRecordCopyWithImpl(this._self, this._then);

  final DnsRecord _self;
  final $Res Function(DnsRecord) _then;

  /// Create a copy of DnsRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? TC = null,
    Object? RD = null,
    Object? RA = null,
    Object? AD = null,
    Object? CD = null,
    Object? ednsClientSubnet = freezed,
    Object? answer = freezed,
    Object? comment = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      TC: null == TC
          ? _self.TC
          : TC // ignore: cast_nullable_to_non_nullable
              as bool,
      RD: null == RD
          ? _self.RD
          : RD // ignore: cast_nullable_to_non_nullable
              as bool,
      RA: null == RA
          ? _self.RA
          : RA // ignore: cast_nullable_to_non_nullable
              as bool,
      AD: null == AD
          ? _self.AD
          : AD // ignore: cast_nullable_to_non_nullable
              as bool,
      CD: null == CD
          ? _self.CD
          : CD // ignore: cast_nullable_to_non_nullable
              as bool,
      ednsClientSubnet: freezed == ednsClientSubnet
          ? _self.ednsClientSubnet
          : ednsClientSubnet // ignore: cast_nullable_to_non_nullable
              as String?,
      answer: freezed == answer
          ? _self.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as List<Answer>?,
      comment: freezed == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [DnsRecord].
extension DnsRecordPatterns on DnsRecord {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DnsRecord value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DnsRecord() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DnsRecord value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DnsRecord():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DnsRecord value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DnsRecord() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'Status') int status,
            bool TC,
            bool RD,
            bool RA,
            bool AD,
            bool CD,
            @JsonKey(name: 'edns_client_subnet') String? ednsClientSubnet,
            @JsonKey(name: 'Answer') List<Answer>? answer,
            @JsonKey(name: 'Comment') String? comment)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DnsRecord() when $default != null:
        return $default(_that.status, _that.TC, _that.RD, _that.RA, _that.AD,
            _that.CD, _that.ednsClientSubnet, _that.answer, _that.comment);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'Status') int status,
            bool TC,
            bool RD,
            bool RA,
            bool AD,
            bool CD,
            @JsonKey(name: 'edns_client_subnet') String? ednsClientSubnet,
            @JsonKey(name: 'Answer') List<Answer>? answer,
            @JsonKey(name: 'Comment') String? comment)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DnsRecord():
        return $default(_that.status, _that.TC, _that.RD, _that.RA, _that.AD,
            _that.CD, _that.ednsClientSubnet, _that.answer, _that.comment);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'Status') int status,
            bool TC,
            bool RD,
            bool RA,
            bool AD,
            bool CD,
            @JsonKey(name: 'edns_client_subnet') String? ednsClientSubnet,
            @JsonKey(name: 'Answer') List<Answer>? answer,
            @JsonKey(name: 'Comment') String? comment)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DnsRecord() when $default != null:
        return $default(_that.status, _that.TC, _that.RD, _that.RA, _that.AD,
            _that.CD, _that.ednsClientSubnet, _that.answer, _that.comment);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DnsRecord extends DnsRecord {
  const _DnsRecord(
      @JsonKey(name: 'Status') this.status,
      this.TC,
      this.RD,
      this.RA,
      this.AD,
      this.CD,
      @JsonKey(name: 'edns_client_subnet') this.ednsClientSubnet,
      @JsonKey(name: 'Answer') final List<Answer>? answer,
      @JsonKey(name: 'Comment') this.comment)
      : _answer = answer,
        super._();
  factory _DnsRecord.fromJson(Map<String, dynamic> json) =>
      _$DnsRecordFromJson(json);

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
  final String? ednsClientSubnet;
  final List<Answer>? _answer;
  @override
  @JsonKey(name: 'Answer')
  List<Answer>? get answer {
    final value = _answer;
    if (value == null) return null;
    if (_answer is EqualUnmodifiableListView) return _answer;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'Comment')
  final String? comment;

  /// Create a copy of DnsRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DnsRecordCopyWith<_DnsRecord> get copyWith =>
      __$DnsRecordCopyWithImpl<_DnsRecord>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DnsRecordToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DnsRecord &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.TC, TC) || other.TC == TC) &&
            (identical(other.RD, RD) || other.RD == RD) &&
            (identical(other.RA, RA) || other.RA == RA) &&
            (identical(other.AD, AD) || other.AD == AD) &&
            (identical(other.CD, CD) || other.CD == CD) &&
            (identical(other.ednsClientSubnet, ednsClientSubnet) ||
                other.ednsClientSubnet == ednsClientSubnet) &&
            const DeepCollectionEquality().equals(other._answer, _answer) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, TC, RD, RA, AD, CD,
      ednsClientSubnet, const DeepCollectionEquality().hash(_answer), comment);

  @override
  String toString() {
    return 'DnsRecord(status: $status, TC: $TC, RD: $RD, RA: $RA, AD: $AD, CD: $CD, ednsClientSubnet: $ednsClientSubnet, answer: $answer, comment: $comment)';
  }
}

/// @nodoc
abstract mixin class _$DnsRecordCopyWith<$Res>
    implements $DnsRecordCopyWith<$Res> {
  factory _$DnsRecordCopyWith(
          _DnsRecord value, $Res Function(_DnsRecord) _then) =
      __$DnsRecordCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'Status') int status,
      bool TC,
      bool RD,
      bool RA,
      bool AD,
      bool CD,
      @JsonKey(name: 'edns_client_subnet') String? ednsClientSubnet,
      @JsonKey(name: 'Answer') List<Answer>? answer,
      @JsonKey(name: 'Comment') String? comment});
}

/// @nodoc
class __$DnsRecordCopyWithImpl<$Res> implements _$DnsRecordCopyWith<$Res> {
  __$DnsRecordCopyWithImpl(this._self, this._then);

  final _DnsRecord _self;
  final $Res Function(_DnsRecord) _then;

  /// Create a copy of DnsRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? TC = null,
    Object? RD = null,
    Object? RA = null,
    Object? AD = null,
    Object? CD = null,
    Object? ednsClientSubnet = freezed,
    Object? answer = freezed,
    Object? comment = freezed,
  }) {
    return _then(_DnsRecord(
      null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      null == TC
          ? _self.TC
          : TC // ignore: cast_nullable_to_non_nullable
              as bool,
      null == RD
          ? _self.RD
          : RD // ignore: cast_nullable_to_non_nullable
              as bool,
      null == RA
          ? _self.RA
          : RA // ignore: cast_nullable_to_non_nullable
              as bool,
      null == AD
          ? _self.AD
          : AD // ignore: cast_nullable_to_non_nullable
              as bool,
      null == CD
          ? _self.CD
          : CD // ignore: cast_nullable_to_non_nullable
              as bool,
      freezed == ednsClientSubnet
          ? _self.ednsClientSubnet
          : ednsClientSubnet // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == answer
          ? _self._answer
          : answer // ignore: cast_nullable_to_non_nullable
              as List<Answer>?,
      freezed == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$Question {
  String get name;
  int get type;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QuestionCopyWith<Question> get copyWith =>
      _$QuestionCopyWithImpl<Question>(this as Question, _$identity);

  /// Serializes this Question to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Question &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, type);

  @override
  String toString() {
    return 'Question(name: $name, type: $type)';
  }
}

/// @nodoc
abstract mixin class $QuestionCopyWith<$Res> {
  factory $QuestionCopyWith(Question value, $Res Function(Question) _then) =
      _$QuestionCopyWithImpl;
  @useResult
  $Res call({String name, int type});
}

/// @nodoc
class _$QuestionCopyWithImpl<$Res> implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._self, this._then);

  final Question _self;
  final $Res Function(Question) _then;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [Question].
extension QuestionPatterns on Question {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Question value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Question() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Question value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Question():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Question value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Question() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String name, int type)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Question() when $default != null:
        return $default(_that.name, _that.type);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String name, int type) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Question():
        return $default(_that.name, _that.type);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String name, int type)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Question() when $default != null:
        return $default(_that.name, _that.type);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Question implements Question {
  const _Question(this.name, this.type);
  factory _Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  @override
  final String name;
  @override
  final int type;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$QuestionCopyWith<_Question> get copyWith =>
      __$QuestionCopyWithImpl<_Question>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$QuestionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Question &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, type);

  @override
  String toString() {
    return 'Question(name: $name, type: $type)';
  }
}

/// @nodoc
abstract mixin class _$QuestionCopyWith<$Res>
    implements $QuestionCopyWith<$Res> {
  factory _$QuestionCopyWith(_Question value, $Res Function(_Question) _then) =
      __$QuestionCopyWithImpl;
  @override
  @useResult
  $Res call({String name, int type});
}

/// @nodoc
class __$QuestionCopyWithImpl<$Res> implements _$QuestionCopyWith<$Res> {
  __$QuestionCopyWithImpl(this._self, this._then);

  final _Question _self;
  final $Res Function(_Question) _then;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? type = null,
  }) {
    return _then(_Question(
      null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$Answer {
  String get name;
  int get type;
  int get TTL;
  String get data;

  /// Create a copy of Answer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AnswerCopyWith<Answer> get copyWith =>
      _$AnswerCopyWithImpl<Answer>(this as Answer, _$identity);

  /// Serializes this Answer to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Answer &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.TTL, TTL) || other.TTL == TTL) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, type, TTL, data);

  @override
  String toString() {
    return 'Answer(name: $name, type: $type, TTL: $TTL, data: $data)';
  }
}

/// @nodoc
abstract mixin class $AnswerCopyWith<$Res> {
  factory $AnswerCopyWith(Answer value, $Res Function(Answer) _then) =
      _$AnswerCopyWithImpl;
  @useResult
  $Res call({String name, int type, int TTL, String data});
}

/// @nodoc
class _$AnswerCopyWithImpl<$Res> implements $AnswerCopyWith<$Res> {
  _$AnswerCopyWithImpl(this._self, this._then);

  final Answer _self;
  final $Res Function(Answer) _then;

  /// Create a copy of Answer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? TTL = null,
    Object? data = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      TTL: null == TTL
          ? _self.TTL
          : TTL // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [Answer].
extension AnswerPatterns on Answer {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Answer value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Answer() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Answer value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Answer():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Answer value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Answer() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String name, int type, int TTL, String data)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Answer() when $default != null:
        return $default(_that.name, _that.type, _that.TTL, _that.data);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String name, int type, int TTL, String data) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Answer():
        return $default(_that.name, _that.type, _that.TTL, _that.data);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String name, int type, int TTL, String data)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Answer() when $default != null:
        return $default(_that.name, _that.type, _that.TTL, _that.data);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Answer implements Answer {
  const _Answer(this.name, this.type, this.TTL, this.data);
  factory _Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  @override
  final String name;
  @override
  final int type;
  @override
  final int TTL;
  @override
  final String data;

  /// Create a copy of Answer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AnswerCopyWith<_Answer> get copyWith =>
      __$AnswerCopyWithImpl<_Answer>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AnswerToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Answer &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.TTL, TTL) || other.TTL == TTL) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, type, TTL, data);

  @override
  String toString() {
    return 'Answer(name: $name, type: $type, TTL: $TTL, data: $data)';
  }
}

/// @nodoc
abstract mixin class _$AnswerCopyWith<$Res> implements $AnswerCopyWith<$Res> {
  factory _$AnswerCopyWith(_Answer value, $Res Function(_Answer) _then) =
      __$AnswerCopyWithImpl;
  @override
  @useResult
  $Res call({String name, int type, int TTL, String data});
}

/// @nodoc
class __$AnswerCopyWithImpl<$Res> implements _$AnswerCopyWith<$Res> {
  __$AnswerCopyWithImpl(this._self, this._then);

  final _Answer _self;
  final $Res Function(_Answer) _then;

  /// Create a copy of Answer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? TTL = null,
    Object? data = null,
  }) {
    return _then(_Answer(
      null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      null == TTL
          ? _self.TTL
          : TTL // ignore: cast_nullable_to_non_nullable
              as int,
      null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
