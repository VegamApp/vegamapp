// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserData on _UserDataBase, Store {
  late final _$_dataAtom = Atom(name: '_UserDataBase._data', context: context);

  @override
  User get _data {
    _$_dataAtom.reportRead();
    return super._data;
  }

  @override
  set _data(User value) {
    _$_dataAtom.reportWrite(value, super._data, () {
      super._data = value;
    });
  }

  late final _$_isLoadingAtom =
      Atom(name: '_UserDataBase._isLoading', context: context);

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

  late final _$addressesListAtom =
      Atom(name: '_UserDataBase.addressesList', context: context);

  @override
  ObservableList<Addresses> get addressesList {
    _$addressesListAtom.reportRead();
    return super.addressesList;
  }

  @override
  set addressesList(ObservableList<Addresses> value) {
    _$addressesListAtom.reportWrite(value, super.addressesList, () {
      super.addressesList = value;
    });
  }

  late final _$getUserDataAsyncAction =
      AsyncAction('_UserDataBase.getUserData', context: context);

  @override
  Future<bool> getUserData(BuildContext context) {
    return _$getUserDataAsyncAction.run(() => super.getUserData(context));
  }

  late final _$_UserDataBaseActionController =
      ActionController(name: '_UserDataBase', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$_UserDataBaseActionController.startAction(
        name: '_UserDataBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_UserDataBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic putData(User data) {
    final _$actionInfo = _$_UserDataBaseActionController.startAction(
        name: '_UserDataBase.putData');
    try {
      return super.putData(data);
    } finally {
      _$_UserDataBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearUserData() {
    final _$actionInfo = _$_UserDataBaseActionController.startAction(
        name: '_UserDataBase.clearUserData');
    try {
      return super.clearUserData();
    } finally {
      _$_UserDataBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeAddress(Addresses address) {
    final _$actionInfo = _$_UserDataBaseActionController.startAction(
        name: '_UserDataBase.removeAddress');
    try {
      return super.removeAddress(address);
    } finally {
      _$_UserDataBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
addressesList: ${addressesList}
    ''';
  }
}
