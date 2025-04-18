// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NavigationState extends NavigationState {
  @override
  final int currentIndex;

  factory _$NavigationState([void Function(NavigationStateBuilder)? updates]) =>
      (new NavigationStateBuilder()..update(updates))._build();

  _$NavigationState._({required this.currentIndex}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        currentIndex, r'NavigationState', 'currentIndex');
  }

  @override
  NavigationState rebuild(void Function(NavigationStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NavigationStateBuilder toBuilder() =>
      new NavigationStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NavigationState && currentIndex == other.currentIndex;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentIndex.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NavigationState')
          ..add('currentIndex', currentIndex))
        .toString();
  }
}

class NavigationStateBuilder
    implements Builder<NavigationState, NavigationStateBuilder> {
  _$NavigationState? _$v;

  int? _currentIndex;
  int? get currentIndex => _$this._currentIndex;
  set currentIndex(int? currentIndex) => _$this._currentIndex = currentIndex;

  NavigationStateBuilder();

  NavigationStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentIndex = $v.currentIndex;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NavigationState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NavigationState;
  }

  @override
  void update(void Function(NavigationStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NavigationState build() => _build();

  _$NavigationState _build() {
    final _$result = _$v ??
        new _$NavigationState._(
          currentIndex: BuiltValueNullFieldError.checkNotNull(
              currentIndex, r'NavigationState', 'currentIndex'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
