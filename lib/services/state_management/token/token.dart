
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart' hide Store;
import 'package:m2/services/api_services/customer_apis.dart';
import 'package:m2/services/models/user.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'token.g.dart';

class AuthToken = _AuthTokenBase with _$AuthToken;

abstract class _AuthTokenBase with Store {
  _AuthTokenBase(this._loginToken);

  @observable
  String? _loginToken;

  @computed
  String? get loginToken => _loginToken;

  @observable
  int _wishlistCount = 0;

  @computed
  int get wishlistCount => _wishlistCount;

  @observable
  User user = User();

  @observable
  bool isLoading = false;

  @action
  putLoading(bool value) {
    isLoading = value;
  }

  @action
  putWishlistCount(int count) {
    _wishlistCount = count;
  }

  @action
  putLoginToken(String? token) {
    _loginToken = token;
  }

  @action
  clearLoginToken() {
    _loginToken = null;
  }

  @action
  putUserData(User data) {
    user = data;
  }

  @action
  getUser(context, ValueNotifier<GraphQLClient> graphqlClient) async {
    putLoading(true);
    // ValueNotifier<GraphQLClient> graphqlClient = GraphQLProvider.of(context);
    QueryResult? result = await graphqlClient.value.mutate(MutationOptions(document: CustomerApis.requestUserData));
    if (result.hasException) {
      try {
        if (result.exception!.graphqlErrors[0].extensions!['category'] == 'graphql-authorization') {
          clearLoginToken();
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.clear();
          return;
        }
      } catch (e) {}
    }

    // try {
    // store user data
    // log('user: ${jsonEncode(result.data)}');
    putUserData(User.fromJson(result.data!['customer']));
    putWishlistCount(result.data!['customer']['wishlists'][0]['items_count']);
    // } catch (e) {
    //   print(e);
    // }

    putLoading(false);
  }
}
