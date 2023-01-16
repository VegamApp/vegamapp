// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthToken on _AuthTokenBase, Store {
  late final _$_loginTokenAtom =
      Atom(name: '_AuthTokenBase._loginToken', context: context);

  @override
  String? get _loginToken {
    _$_loginTokenAtom.reportRead();
    return super._loginToken;
  }

  @override
  set _loginToken(String? value) {
    _$_loginTokenAtom.reportWrite(value, super._loginToken, () {
      super._loginToken = value;
    });
  }

  late final _$_cartIdAtom =
      Atom(name: '_AuthTokenBase._cartId', context: context);

  @override
  String? get _cartId {
    _$_cartIdAtom.reportRead();
    return super._cartId;
  }

  @override
  set _cartId(String? value) {
    _$_cartIdAtom.reportWrite(value, super._cartId, () {
      super._cartId = value;
    });
  }

  late final _$_cartCountAtom =
      Atom(name: '_AuthTokenBase._cartCount', context: context);

  @override
  int get _cartCount {
    _$_cartCountAtom.reportRead();
    return super._cartCount;
  }

  @override
  set _cartCount(int value) {
    _$_cartCountAtom.reportWrite(value, super._cartCount, () {
      super._cartCount = value;
    });
  }

  late final _$_wishlistCountAtom =
      Atom(name: '_AuthTokenBase._wishlistCount', context: context);

  @override
  int get _wishlistCount {
    _$_wishlistCountAtom.reportRead();
    return super._wishlistCount;
  }

  @override
  set _wishlistCount(int value) {
    _$_wishlistCountAtom.reportWrite(value, super._wishlistCount, () {
      super._wishlistCount = value;
    });
  }

  late final _$_AuthTokenBaseActionController =
      ActionController(name: '_AuthTokenBase', context: context);

  @override
  dynamic putWishlistCount(int count) {
    final _$actionInfo = _$_AuthTokenBaseActionController.startAction(
        name: '_AuthTokenBase.putWishlistCount');
    try {
      return super.putWishlistCount(count);
    } finally {
      _$_AuthTokenBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic putLoginToken(String token) {
    final _$actionInfo = _$_AuthTokenBaseActionController.startAction(
        name: '_AuthTokenBase.putLoginToken');
    try {
      return super.putLoginToken(token);
    } finally {
      _$_AuthTokenBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearLoginToken() {
    final _$actionInfo = _$_AuthTokenBaseActionController.startAction(
        name: '_AuthTokenBase.clearLoginToken');
    try {
      return super.clearLoginToken();
    } finally {
      _$_AuthTokenBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic putCartCount(int count) {
    final _$actionInfo = _$_AuthTokenBaseActionController.startAction(
        name: '_AuthTokenBase.putCartCount');
    try {
      return super.putCartCount(count);
    } finally {
      _$_AuthTokenBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic putCartId(String newCartId) {
    final _$actionInfo = _$_AuthTokenBaseActionController.startAction(
        name: '_AuthTokenBase.putCartId');
    try {
      return super.putCartId(newCartId);
    } finally {
      _$_AuthTokenBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
