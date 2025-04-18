import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/material.dart' hide Builder;

part 'tutorial_step.g.dart';

abstract class TutorialStep
    implements Built<TutorialStep, TutorialStepBuilder> {
  String get title;
  String get description;
  Offset get position;
  Size get size;

  TutorialStep._();
  factory TutorialStep([void Function(TutorialStepBuilder) updates]) =
      _$TutorialStep;
  static Serializer<TutorialStep> get serializer => _$tutorialStepSerializer;
}
