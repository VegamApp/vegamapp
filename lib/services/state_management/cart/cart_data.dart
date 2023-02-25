import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart' hide Store;
import 'package:m2/services/api_services/api_services.dart';
import 'package:m2/services/api_services/cart_apis.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'cart_data.g.dart';

// ignore: library_private_types_in_public_api
class CartData = _CartDataBase with _$CartData;

abstract class _CartDataBase with Store {
  @observable
  String? _cartId;
  String? get cartId => _cartId;

  @observable
  int _cartCount = 0;
  int get cartCount => _cartCount;

  @observable
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @observable
  Map<String, dynamic> _cartData = {};
  Map<String, dynamic> get cartData => _cartData;

  @action
  putCartCount(int count) {
    _cartCount = count;
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
    _cartData = data;
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
  getCartData(BuildContext context) async {
    setLoading(true);
    var graphqlClient = GraphQLProvider.of(context);
    QueryResult? result = await graphqlClient.value.query(WatchQueryOptions(document: CartApis.cart, variables: {'id': _cartId}));
    if (result.hasException) {
      print(result.exception);
    } else {
      // putCartCount(result.data!['cart']['total_quantity']);
      setCartData(result.data!);
    }
    setLoading(false);
  }

  @action
  getGuestCart(BuildContext context) async {
    setLoading(true);
    var graphqlClient = GraphQLProvider.of(context);
    QueryResult? result = await graphqlClient.value.mutate(
      MutationOptions(document: gql("mutation {createEmptyCart}")),
    );
    await setToken(result.data!['createEmptyCart']);
    setLoading(false);
  }

  @action
  getCustomerCart(BuildContext context) async {
    setLoading(true);
    var graphqlClient = GraphQLProvider.of(context);
    QueryResult? result = await graphqlClient.value.query(
      QueryOptions(document: gql("{customerCart {id}}")),
    );
    try {
      await mergeCarts(graphqlClient, result.data!['customerCart']['id']);
    } catch (e) {
      await setToken(result.data!['customerCart']['id']);
    }
    setLoading(false);
  }

  @action
  mergeCarts(ValueNotifier<GraphQLClient> graphqlClient, String newCart) async {
    QueryResult? result = await graphqlClient.value.mutate(
      MutationOptions(document: gql(CartApis.mergeCart), variables: {'oldCart': _cartId, 'newCart': newCart}),
    );
    print(result.data);
    if (result.data != null) setToken(newCart);
  }

  setToken(String cartId) async {
    // get previously stored token if any.
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('cartId', cartId);
    putCartId(cartId);
    putCartCount(0);
  }
}
