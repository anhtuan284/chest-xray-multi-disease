// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ImageAsset> _$imageAssetSerializer = new _$ImageAssetSerializer();

class _$ImageAssetSerializer implements StructuredSerializer<ImageAsset> {
  @override
  final Iterable<Type> types = const [ImageAsset, _$ImageAsset];
  @override
  final String wireName = 'ImageAsset';

  @override
  Iterable<Object?> serialize(Serializers serializers, ImageAsset object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.url;
    if (value != null) {
      result
        ..add('url')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.localPath;
    if (value != null) {
      result
        ..add('localPath')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  ImageAsset deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ImageAssetBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'url':
          result.url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'localPath':
          result.localPath = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$ImageAsset extends ImageAsset {
  @override
  final String? url;
  @override
  final String? localPath;

  factory _$ImageAsset([void Function(ImageAssetBuilder)? updates]) =>
      (new ImageAssetBuilder()..update(updates))._build();

  _$ImageAsset._({this.url, this.localPath}) : super._();

  @override
  ImageAsset rebuild(void Function(ImageAssetBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImageAssetBuilder toBuilder() => new ImageAssetBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImageAsset &&
        url == other.url &&
        localPath == other.localPath;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, localPath.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ImageAsset')
          ..add('url', url)
          ..add('localPath', localPath))
        .toString();
  }
}

class ImageAssetBuilder implements Builder<ImageAsset, ImageAssetBuilder> {
  _$ImageAsset? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  String? _localPath;
  String? get localPath => _$this._localPath;
  set localPath(String? localPath) => _$this._localPath = localPath;

  ImageAssetBuilder();

  ImageAssetBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _localPath = $v.localPath;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImageAsset other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ImageAsset;
  }

  @override
  void update(void Function(ImageAssetBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ImageAsset build() => _build();

  _$ImageAsset _build() {
    final _$result = _$v ??
        new _$ImageAsset._(
          url: url,
          localPath: localPath,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
