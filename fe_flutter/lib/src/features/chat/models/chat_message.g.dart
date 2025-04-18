// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ChatMessage> _$chatMessageSerializer = new _$ChatMessageSerializer();

class _$ChatMessageSerializer implements StructuredSerializer<ChatMessage> {
  @override
  final Iterable<Type> types = const [ChatMessage, _$ChatMessage];
  @override
  final String wireName = 'ChatMessage';

  @override
  Iterable<Object?> serialize(Serializers serializers, ChatMessage object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'message',
      serializers.serialize(object.message,
          specifiedType: const FullType(String)),
      'isUser',
      serializers.serialize(object.isUser, specifiedType: const FullType(bool)),
      'timestamp',
      serializers.serialize(object.timestamp,
          specifiedType: const FullType(DateTime)),
    ];

    return result;
  }

  @override
  ChatMessage deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChatMessageBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'isUser':
          result.isUser = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'timestamp':
          result.timestamp = serializers.deserialize(value,
              specifiedType: const FullType(DateTime))! as DateTime;
          break;
      }
    }

    return result.build();
  }
}

class _$ChatMessage extends ChatMessage {
  @override
  final String message;
  @override
  final bool isUser;
  @override
  final DateTime timestamp;

  factory _$ChatMessage([void Function(ChatMessageBuilder)? updates]) =>
      (new ChatMessageBuilder()..update(updates))._build();

  _$ChatMessage._(
      {required this.message, required this.isUser, required this.timestamp})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(message, r'ChatMessage', 'message');
    BuiltValueNullFieldError.checkNotNull(isUser, r'ChatMessage', 'isUser');
    BuiltValueNullFieldError.checkNotNull(
        timestamp, r'ChatMessage', 'timestamp');
  }

  @override
  ChatMessage rebuild(void Function(ChatMessageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatMessageBuilder toBuilder() => new ChatMessageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatMessage &&
        message == other.message &&
        isUser == other.isUser &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, isUser.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatMessage')
          ..add('message', message)
          ..add('isUser', isUser)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class ChatMessageBuilder implements Builder<ChatMessage, ChatMessageBuilder> {
  _$ChatMessage? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  bool? _isUser;
  bool? get isUser => _$this._isUser;
  set isUser(bool? isUser) => _$this._isUser = isUser;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  ChatMessageBuilder();

  ChatMessageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _isUser = $v.isUser;
      _timestamp = $v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatMessage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatMessage;
  }

  @override
  void update(void Function(ChatMessageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatMessage build() => _build();

  _$ChatMessage _build() {
    final _$result = _$v ??
        new _$ChatMessage._(
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'ChatMessage', 'message'),
          isUser: BuiltValueNullFieldError.checkNotNull(
              isUser, r'ChatMessage', 'isUser'),
          timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp, r'ChatMessage', 'timestamp'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
