// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_dart.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WishlistData on _WishlistDataBase, Store {
  Computed<int>? _$wishlistCountComputed;

  @override
  int get wishlistCount =>
      (_$wishlistCountComputed ??= Computed<int>(() => super.wishlistCount,
              name: '_WishlistDataBase.wishlistCount'))
          .value;
  Computed<Wishlist?>? _$wishlistComputed;

  @override
  Wishlist? get wishlist =>
      (_$wishlistComputed ??= Computed<Wishlist?>(() => super.wishlist,
              name: '_WishlistDataBase.wishlist'))
          .value;
  Computed<bool>? _$hasExceptionsComputed;

  @override
  bool get hasExceptions =>
      (_$hasExceptionsComputed ??= Computed<bool>(() => super.hasExceptions,
              name: '_WishlistDataBase.hasExceptions'))
          .value;
  Computed<String?>? _$errorMsgComputed;

  @override
  String? get errorMsg =>
      (_$errorMsgComputed ??= Computed<String?>(() => super.errorMsg,
              name: '_WishlistDataBase.errorMsg'))
          .value;

  late final _$_wishlistCountAtom =
      Atom(name: '_WishlistDataBase._wishlistCount', context: context);

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

  late final _$_wishlistAtom =
      Atom(name: '_WishlistDataBase._wishlist', context: context);

  @override
  Wishlist? get _wishlist {
    _$_wishlistAtom.reportRead();
    return super._wishlist;
  }

  @override
  set _wishlist(Wishlist? value) {
    _$_wishlistAtom.reportWrite(value, super._wishlist, () {
      super._wishlist = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_WishlistDataBase.isLoading', context: context);

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

  late final _$_hasExceptionsAtom =
      Atom(name: '_WishlistDataBase._hasExceptions', context: context);

  @override
  bool get _hasExceptions {
    _$_hasExceptionsAtom.reportRead();
    return super._hasExceptions;
  }

  @override
  set _hasExceptions(bool value) {
    _$_hasExceptionsAtom.reportWrite(value, super._hasExceptions, () {
      super._hasExceptions = value;
    });
  }

  late final _$_errorMsgAtom =
      Atom(name: '_WishlistDataBase._errorMsg', context: context);

  @override
  String? get _errorMsg {
    _$_errorMsgAtom.reportRead();
    return super._errorMsg;
  }

  @override
  set _errorMsg(String? value) {
    _$_errorMsgAtom.reportWrite(value, super._errorMsg, () {
      super._errorMsg = value;
    });
  }

  late final _$getWishlistDataAsyncAction =
      AsyncAction('_WishlistDataBase.getWishlistData', context: context);

  @override
  Future getWishlistData(BuildContext context) {
    return _$getWishlistDataAsyncAction
        .run(() => super.getWishlistData(context));
  }

  late final _$_WishlistDataBaseActionController =
      ActionController(name: '_WishlistDataBase', context: context);

  @override
  dynamic putLoading(bool value) {
    final _$actionInfo = _$_WishlistDataBaseActionController.startAction(
        name: '_WishlistDataBase.putLoading');
    try {
      return super.putLoading(value);
    } finally {
      _$_WishlistDataBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic putWishlistCount(int count) {
    final _$actionInfo = _$_WishlistDataBaseActionController.startAction(
        name: '_WishlistDataBase.putWishlistCount');
    try {
      return super.putWishlistCount(count);
    } finally {
      _$_WishlistDataBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
wishlistCount: ${wishlistCount},
wishlist: ${wishlist},
hasExceptions: ${hasExceptions},
errorMsg: ${errorMsg}
    ''';
  }
}
