import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart' hide Store;
import 'package:m2/services/api_services/api_services.dart';
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
  putCartId(String newCartId) {
    _cartId = newCartId;
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
    QueryResult? result = await graphqlClient.value.query(WatchQueryOptions(document: ApiServices.cart, variables: {'id': _cartId}));
    print(result.data);
    setCartData(result.data!);
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
    await setToken(result.data!['customerCart']['id']);
    setLoading(false);
  }

  setToken(String cartId) async {
    // print(cartId);
    // get previously stored token if any.
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('cartId', cartId);
    putCartId(cartId);
    putCartCount(0);
  }
}
