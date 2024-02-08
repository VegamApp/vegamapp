// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_data.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CartData on _CartDataBase, Store {
  Computed<String?>? _$cartIdComputed;

  @override
  String? get cartId => (_$cartIdComputed ??=
          Computed<String?>(() => super.cartId, name: '_CartDataBase.cartId'))
      .value;
  Computed<int>? _$cartCountComputed;

  @override
  int get cartCount => (_$cartCountComputed ??=
          Computed<int>(() => super.cartCount, name: '_CartDataBase.cartCount'))
      .value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(() => super.isLoading,
              name: '_CartDataBase.isLoading'))
          .value;
  Computed<bool?>? _$isVirtualCartComputed;

  @override
  bool? get isVirtualCart =>
      (_$isVirtualCartComputed ??= Computed<bool?>(() => super.isVirtualCart,
              name: '_CartDataBase.isVirtualCart'))
          .value;
  Computed<double>? _$grandTotalComputed;

  @override
  double get grandTotal =>
      (_$grandTotalComputed ??= Computed<double>(() => super.grandTotal,
              name: '_CartDataBase.grandTotal'))
          .value;
  Computed<bool>? _$hasExceptionsComputed;

  @override
  bool get hasExceptions =>
      (_$hasExceptionsComputed ??= Computed<bool>(() => super.hasExceptions,
              name: '_CartDataBase.hasExceptions'))
          .value;
  Computed<Map<String, dynamic>>? _$cartDataComputed;

  @override
  Map<String, dynamic> get cartData => (_$cartDataComputed ??=
          Computed<Map<String, dynamic>>(() => super.cartData,
              name: '_CartDataBase.cartData'))
      .value;
  Computed<OperationException?>? _$exceptionComputed;

  @override
  OperationException? get exception => (_$exceptionComputed ??=
          Computed<OperationException?>(() => super.exception,
              name: '_CartDataBase.exception'))
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

  late final _$_isVirtualCartAtom =
      Atom(name: '_CartDataBase._isVirtualCart', context: context);

  @override
  bool? get _isVirtualCart {
    _$_isVirtualCartAtom.reportRead();
    return super._isVirtualCart;
  }

  @override
  set _isVirtualCart(bool? value) {
    _$_isVirtualCartAtom.reportWrite(value, super._isVirtualCart, () {
      super._isVirtualCart = value;
    });
  }

  late final _$_grandTotalAtom =
      Atom(name: '_CartDataBase._grandTotal', context: context);

  @override
  double get _grandTotal {
    _$_grandTotalAtom.reportRead();
    return super._grandTotal;
  }

  @override
  set _grandTotal(double value) {
    _$_grandTotalAtom.reportWrite(value, super._grandTotal, () {
      super._grandTotal = value;
    });
  }

  late final _$_hasExceptionsAtom =
      Atom(name: '_CartDataBase._hasExceptions', context: context);

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

  late final _$_cartDataAtom =
      Atom(name: '_CartDataBase._cartData', context: context);

  @override
  ObservableMap<String, dynamic> get _cartData {
    _$_cartDataAtom.reportRead();
    return super._cartData;
  }

  @override
  set _cartData(ObservableMap<String, dynamic> value) {
    _$_cartDataAtom.reportWrite(value, super._cartData, () {
      super._cartData = value;
    });
  }

  late final _$_exceptionAtom =
      Atom(name: '_CartDataBase._exception', context: context);

  @override
  OperationException? get _exception {
    _$_exceptionAtom.reportRead();
    return super._exception;
  }

  @override
  set _exception(OperationException? value) {
    _$_exceptionAtom.reportWrite(value, super._exception, () {
      super._exception = value;
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
  Future mergeCarts(BuildContext context, String newCart) {
    return _$mergeCartsAsyncAction
        .run(() => super.mergeCarts(context, newCart));
  }

  late final _$setTokenAsyncAction =
      AsyncAction('_CartDataBase.setToken', context: context);

  @override
  Future setToken(String cartId, int cartCount) {
    return _$setTokenAsyncAction.run(() => super.setToken(cartId, cartCount));
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
  dynamic putCartPrice(double amount) {
    final _$actionInfo = _$_CartDataBaseActionController.startAction(
        name: '_CartDataBase.putCartPrice');
    try {
      return super.putCartPrice(amount);
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
  dynamic setVirtualCart(bool? value) {
    final _$actionInfo = _$_CartDataBaseActionController.startAction(
        name: '_CartDataBase.setVirtualCart');
    try {
      return super.setVirtualCart(value);
    } finally {
      _$_CartDataBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool? checkVirtualCart() {
    final _$actionInfo = _$_CartDataBaseActionController.startAction(
        name: '_CartDataBase.checkVirtualCart');
    try {
      return super.checkVirtualCart();
    } finally {
      _$_CartDataBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cartId: ${cartId},
cartCount: ${cartCount},
isLoading: ${isLoading},
isVirtualCart: ${isVirtualCart},
grandTotal: ${grandTotal},
hasExceptions: ${hasExceptions},
cartData: ${cartData},
exception: ${exception}
    ''';
  }
}
