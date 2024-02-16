// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_manager.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CacheManager on _CacheManagerBase, Store {
  late final _$iAtom = Atom(name: '_CacheManagerBase.i', context: context);

  @override
  int get i {
    _$iAtom.reportRead();
    return super.i;
  }

  @override
  set i(int value) {
    _$iAtom.reportWrite(value, super.i, () {
      super.i = value;
    });
  }

  late final _$_CacheManagerBaseActionController =
      ActionController(name: '_CacheManagerBase', context: context);

  @override
  dynamic increment() {
    final _$actionInfo = _$_CacheManagerBaseActionController.startAction(
        name: '_CacheManagerBase.increment');
    try {
      return super.increment();
    } finally {
      _$_CacheManagerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic reset() {
    final _$actionInfo = _$_CacheManagerBaseActionController.startAction(
        name: '_CacheManagerBase.reset');
    try {
      return super.reset();
    } finally {
      _$_CacheManagerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic checkCache(BuildContext context) {
    final _$actionInfo = _$_CacheManagerBaseActionController.startAction(
        name: '_CacheManagerBase.checkCache');
    try {
      return super.checkCache(context);
    } finally {
      _$_CacheManagerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
i: ${i}
    ''';
  }
}
