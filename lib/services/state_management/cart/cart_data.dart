import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart' hide Store;
import 'package:m2/services/api_services/cart_apis.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'cart_data.g.dart';

class CartData = _CartDataBase with _$CartData;

abstract class _CartDataBase with Store {
  _CartDataBase(this._cartId);
  @observable
  String? _cartId;

  @computed
  String? get cartId => _cartId;

  @observable
  int _cartCount = 0;

  @computed
  int get cartCount => _cartCount;

  @observable
  bool _isLoading = false;

  @computed
  bool get isLoading => _isLoading;

  @observable
  bool? _isVirtualCart;

  @computed
  bool? get isVirtualCart => _isVirtualCart;

  @observable
  double _grandTotal = 0;

  @computed
  double get grandTotal => _grandTotal;

  @observable
  bool _hasExceptions = false;

  @computed
  bool get hasExceptions => _hasExceptions;

  @observable
  ObservableMap<String, dynamic> _cartData = ObservableMap<String, dynamic>();

  @computed
  Map<String, dynamic> get cartData => _cartData;

  @observable
  OperationException? _exception;

  @computed
  OperationException? get exception => _exception;

  @action
  putCartCount(int count) {
    _cartCount = count;
  }

  @action
  putCartPrice(double amount) {
    _grandTotal = amount;
  }

  @action
  putCartId(String? newCartId) async {
    _cartId = newCartId;
    if (newCartId != null) {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('cart', newCartId);
    }
  }

  @action
  setCartData(Map<String, dynamic> data) {
    _cartData = ObservableMap<String, dynamic>.of(data);
  }

  @action
  clearCartId() {
    _cartId = null;
  }

  @action
  setLoading(bool value) {
    _isLoading = value;
  }

  @action
  setVirtualCart(bool? value) {
    _isVirtualCart = value;
  }

  @action
  getCartData(BuildContext context, AuthToken token) async {
    setLoading(true);
    var graphqlClient = GraphQLProvider.of(context);
    QueryResult? result = await graphqlClient.value.query(WatchQueryOptions(document: CartApis.cart, variables: {'id': _cartId}));
    // print("cartResult $result");
    if (result.hasException) {
      // var token = Provider.of<AuthToken>(context, listen: false);
      _cartData.clear();
      log(token.loginToken.toString());
      if (token.loginToken == null) {
        await getGuestCart(context);
      } else {
        await getCustomerCart(context, token);
      }
      getCartData(context, token);
    } else {
      // putCartCount(result.data!['cart']['total_quantity']);
      setCartData(result.data!);
      putCartCount(result.data!['cart']['total_quantity']);
    }
    setLoading(false);
  }

  // @action
  // getGuestCart(BuildContext context) async {
  //   setLoading(true);
  //   var graphqlClient = GraphQLProvider.of(context);
  //   QueryResult? result = await graphqlClient.value.mutate(
  //     MutationOptions(document: gql("mutation {createEmptyCart}")),
  //   );
  //   // print(result);
  //   await setToken(result.data!['createEmptyCart']);
  //   setLoading(false);
  // }

  // @action
  // getCustomerCart(BuildContext context, AuthToken token) async {
  //   setLoading(true);
  //   var graphqlClient = GraphQLProvider.of(context);
  //   QueryResult? result = await graphqlClient.value.query(
  //     QueryOptions(document: gql("{customerCart {id}}")),
  //   );
  //   // print("customerCart $result");
  //   if (result.hasException) {
  //     token.clearLoginToken();
  //     token.putWishlistCount(0);
  //   }
  //   {
  //     try {
  //       await mergeCarts(graphqlClient, result.data!['customerCart']['id']);
  //     } catch (e) {
  //       await setToken(result.data!['customerCart']['id']);
  //     }
  //   }
  //   setLoading(false);
  // }

  // @action
  // mergeCarts(ValueNotifier<GraphQLClient> graphqlClient, String newCart) async {
  //   QueryResult? result = await graphqlClient.value.mutate(
  //     MutationOptions(document: gql(CartApis.mergeCart), variables: {'oldCart': _cartId, 'newCart': newCart}),
  //   );
  //   // print(result.data);
  //   setToken(newCart);
  //   return result;
  // }

  // setToken(String cartId) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   sharedPreferences.setString('cartId', cartId);
  //   putCartId(cartId);
  //   putCartCount(0);
  // }
  @action
  bool? checkVirtualCart() {
    for (var i in cartData['cart']['items']) {
      print(i['product']['__typename']);
      if (i['product']['__typename'] != "VirtualProduct") {
        _isVirtualCart = false;
        return false;
      }
    }
    _isVirtualCart = true;
    return true;
  }

  @action
  getGuestCart(BuildContext context) async {
    setLoading(true);
    var graphqlClient = GraphQLProvider.of(context);
    QueryResult? result = await graphqlClient.value.mutate(
      MutationOptions(document: gql("mutation {createEmptyCart}")),
    );
    await setToken(result.data!['createEmptyCart'], 0);
    setLoading(false);
  }

  @action
  getCustomerCart(BuildContext context, AuthToken token) async {
    setLoading(true);
    var graphqlClient = GraphQLProvider.of(context);
    QueryResult? result = await graphqlClient.value.query(
      QueryOptions(document: gql("{customerCart {id\ntotal_quantity}}")),
    );
    log(result.toString());
    if (result.hasException) {
      token.clearLoginToken();
      token.putWishlistCount(0);
    } else {
      try {
        await mergeCarts(context, result.data!['customerCart']['id']);
      } catch (e) {
        await setToken(result.data!['customerCart']['id'], result.data!['customerCart']['total_quantity']);
      }
    }
    setLoading(false);
  }

  @action
  mergeCarts(BuildContext context, String newCart) async {
    var graphqlClient = GraphQLProvider.of(context);
    QueryResult? result = await graphqlClient.value.mutate(
      MutationOptions(document: gql(CartApis.mergeCart), variables: {'oldCart': _cartId, 'newCart': newCart}),
    );
    setToken(newCart, 0);
    return result;
  }

  @action
  setToken(String cartId, int cartCount) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('cartId', cartId);
    putCartId(cartId);
    putCartCount(cartCount);
  }
}
