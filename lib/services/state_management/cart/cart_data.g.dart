// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_data.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CartData on _CartDataBase, Store {
  Computed<int>? _$cartCountComputed;

  @override
  int get cartCount => (_$cartCountComputed ??=
          Computed<int>(() => super.cartCount, name: '_CartDataBase.cartCount'))
      .value;

  late final _$_cartIdAtom =
      Atom(name: '_CartDataBase._cartId', context: context);

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
      Atom(name: '_CartDataBase._cartCount', context: context);

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

  late final _$_isLoadingAtom =
      Atom(name: '_CartDataBase._isLoading', context: context);

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

  late final _$_cartDataAtom =
      Atom(name: '_CartDataBase._cartData', context: context);

  @override
  Map<String, dynamic> get _cartData {
    _$_cartDataAtom.reportRead();
    return super._cartData;
  }

  @override
  set _cartData(Map<String, dynamic> value) {
    _$_cartDataAtom.reportWrite(value, super._cartData, () {
      super._cartData = value;
    });
  }

  late final _$putCartIdAsyncAction =
      AsyncAction('_CartDataBase.putCartId', context: context);

  @override
  Future putCartId(String? newCartId) {
    return _$putCartIdAsyncAction.run(() => super.putCartId(newCartId));
  }

  late final _$getCartDataAsyncAction =
      AsyncAction('_CartDataBase.getCartData', context: context);

  @override
  Future getCartData(BuildContext context, AuthToken token) {
    return _$getCartDataAsyncAction
        .run(() => super.getCartData(context, token));
  }

  late final _$getGuestCartAsyncAction =
      AsyncAction('_CartDataBase.getGuestCart', context: context);

  @override
  Future getGuestCart(BuildContext context) {
    return _$getGuestCartAsyncAction.run(() => super.getGuestCart(context));
  }

  late final _$getCustomerCartAsyncAction =
      AsyncAction('_CartDataBase.getCustomerCart', context: context);

  @override
  Future getCustomerCart(BuildContext context, AuthToken token) {
    return _$getCustomerCartAsyncAction
        .run(() => super.getCustomerCart(context, token));
  }

  late final _$mergeCartsAsyncAction =
      AsyncAction('_CartDataBase.mergeCarts', context: context);

  @override
  Future mergeCarts(
      ValueNotifier<GraphQLClient> graphqlClient, String newCart) {
    return _$mergeCartsAsyncAction
        .run(() => super.mergeCarts(graphqlClient, newCart));
  }

  late final _$_CartDataBaseActionController =
      ActionController(name: '_CartDataBase', context: context);

  @override
  dynamic putCartCount(int count) {
    final _$actionInfo = _$_CartDataBaseActionController.startAction(
        name: '_CartDataBase.putCartCount');
    try {
      return super.putCartCount(count);
    } finally {
      _$_CartDataBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCartData(Map<String, dynamic> data) {
    final _$actionInfo = _$_CartDataBaseActionController.startAction(
        name: '_CartDataBase.setCartData');
    try {
      return super.setCartData(data);
    } finally {
      _$_CartDataBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearCartId() {
    final _$actionInfo = _$_CartDataBaseActionController.startAction(
        name: '_CartDataBase.clearCartId');
    try {
      return super.clearCartId();
    } finally {
      _$_CartDataBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLoading(bool value) {
    final _$actionInfo = _$_CartDataBaseActionController.startAction(
        name: '_CartDataBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_CartDataBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cartCount: ${cartCount}
    ''';
  }
}
