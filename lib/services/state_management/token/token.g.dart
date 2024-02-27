// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthToken on _AuthTokenBase, Store {
  Computed<String?>? _$loginTokenComputed;

  @override
  String? get loginToken =>
      (_$loginTokenComputed ??= Computed<String?>(() => super.loginToken,
              name: '_AuthTokenBase.loginToken'))
          .value;
  Computed<int>? _$wishlistCountComputed;

  @override
  int get wishlistCount =>
      (_$wishlistCountComputed ??= Computed<int>(() => super.wishlistCount,
              name: '_AuthTokenBase.wishlistCount'))
          .value;

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

  late final _$userAtom = Atom(name: '_AuthTokenBase.user', context: context);

  @override
  User get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_AuthTokenBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$getUserAsyncAction =
      AsyncAction('_AuthTokenBase.getUser', context: context);

  @override
  Future getUser(dynamic context, ValueNotifier<GraphQLClient> graphqlClient) {
    return _$getUserAsyncAction
        .run(() => super.getUser(context, graphqlClient));
  }

  late final _$_AuthTokenBaseActionController =
      ActionController(name: '_AuthTokenBase', context: context);

  @override
  dynamic putLoading(bool value) {
    final _$actionInfo = _$_AuthTokenBaseActionController.startAction(
        name: '_AuthTokenBase.putLoading');
    try {
      return super.putLoading(value);
    } finally {
      _$_AuthTokenBaseActionController.endAction(_$actionInfo);
    }
  }

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
  dynamic putLoginToken(String? token) {
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
  dynamic putUserData(User data) {
    final _$actionInfo = _$_AuthTokenBaseActionController.startAction(
        name: '_AuthTokenBase.putUserData');
    try {
      return super.putUserData(data);
    } finally {
      _$_AuthTokenBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user},
isLoading: ${isLoading},
loginToken: ${loginToken},
wishlistCount: ${wishlistCount}
    ''';
  }
}
