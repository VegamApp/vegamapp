// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_data.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeData on _HomeDataBase, Store {
  late final _$_dataAtom = Atom(name: '_HomeDataBase._data', context: context);

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
      Atom(name: '_HomeDataBase._isLoading', context: context);

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

  late final _$getHomeDataAsyncAction =
      AsyncAction('_HomeDataBase.getHomeData', context: context);

  @override
  Future getHomeData(BuildContext context) {
    return _$getHomeDataAsyncAction.run(() => super.getHomeData(context));
  }

  late final _$_HomeDataBaseActionController =
      ActionController(name: '_HomeDataBase', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$_HomeDataBaseActionController.startAction(
        name: '_HomeDataBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_HomeDataBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
