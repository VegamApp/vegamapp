// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_data.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CategoriesData on _CategoriesDataBase, Store {
  late final _$_dataAtom =
      Atom(name: '_CategoriesDataBase._data', context: context);

  @override
  Map<String, dynamic> get _data {
    _$_dataAtom.reportRead();
    return super._data;
  }

  @override
  set _data(Map<String, dynamic> value) {
    _$_dataAtom.reportWrite(value, super._data, () {
      super._data = value;
    });
  }

  late final _$_isLoadingAtom =
      Atom(name: '_CategoriesDataBase._isLoading', context: context);

  @override
  bool get _isLoading {
    _$_isLoadingAtom.reportRead();
    return super._isLoading;
  }

  @override
  set _isLoading(bool value) {
    _$_isLoadingAtom.reportWrite(value, super._isLoading, () {
      super._isLoading = value;
    });
  }

  late final _$_portalTargetsAtom =
      Atom(name: '_CategoriesDataBase._portalTargets', context: context);

  @override
  List<bool> get _portalTargets {
    _$_portalTargetsAtom.reportRead();
    return super._portalTargets;
  }

  @override
  set _portalTargets(List<bool> value) {
    _$_portalTargetsAtom.reportWrite(value, super._portalTargets, () {
      super._portalTargets = value;
    });
  }

  late final _$getCategoryDataAsyncAction =
      AsyncAction('_CategoriesDataBase.getCategoryData', context: context);

  @override
  Future getCategoryData(BuildContext context) {
    return _$getCategoryDataAsyncAction
        .run(() => super.getCategoryData(context));
  }

  late final _$_CategoriesDataBaseActionController =
      ActionController(name: '_CategoriesDataBase', context: context);

  @override
  void populateTargets() {
    final _$actionInfo = _$_CategoriesDataBaseActionController.startAction(
        name: '_CategoriesDataBase.populateTargets');
    try {
      return super.populateTargets();
    } finally {
      _$_CategoriesDataBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void editTargets(int index) {
    final _$actionInfo = _$_CategoriesDataBaseActionController.startAction(
        name: '_CategoriesDataBase.editTargets');
    try {
      return super.editTargets(index);
    } finally {
      _$_CategoriesDataBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$_CategoriesDataBaseActionController.startAction(
        name: '_CategoriesDataBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_CategoriesDataBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
