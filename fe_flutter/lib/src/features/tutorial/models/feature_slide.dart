import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/material.dart' hide Builder;

part 'feature_slide.g.dart';

abstract class FeatureSlide
    implements Built<FeatureSlide, FeatureSlideBuilder> {
  String get title;
  String get description;
  IconData get icon;
  Color get color;
  String? get imagePath;
  Widget? get customWidget;
  @BuiltValueField(serialize: false)
  Map<String, dynamic>? get customAnimation;

  FeatureSlide._();
  factory FeatureSlide([void Function(FeatureSlideBuilder) updates]) =
      _$FeatureSlide;
  static Serializer<FeatureSlide> get serializer => _$featureSlideSerializer;
}
