import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:fe_flutter/src/core/serializers.dart';

part 'image.g.dart';

abstract class ImageAsset implements Built<ImageAsset, ImageAssetBuilder> {
  // Internet URL
  String? get url;

  String? get localPath;

  bool get isLocal => localPath != null;

  // Source path: returns either the local path or the URL
  String get source => localPath ?? url ?? '';

  ImageAsset._();

  factory ImageAsset([void Function(ImageAssetBuilder) updates]) = _$ImageAsset;

  static Serializer<ImageAsset> get serializer => _$imageAssetSerializer;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(ImageAsset.serializer, this)
        as Map<String, dynamic>;
  }

  static ImageAsset? fromJson(Map<String, dynamic>? json) {
    return json == null
        ? null
        : serializers.deserializeWith(ImageAsset.serializer, json);
  }
}
