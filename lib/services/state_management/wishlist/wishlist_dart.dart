import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart' hide Store;
import 'package:m2/services/api_services/customer_apis.dart';
import 'package:m2/services/models/wishlist_model.dart';
import 'package:mobx/mobx.dart';
part 'wishlist_dart.g.dart';

class WishlistData = _WishlistDataBase with _$WishlistData;

abstract class _WishlistDataBase with Store {
  @observable
  int _wishlistCount = 0;

  @computed
  int get wishlistCount => _wishlistCount;

  @observable
  Wishlist? _wishlist;

  @computed
  Wishlist? get wishlist => _wishlist;

  @observable
  bool isLoading = false;

  @observable
  bool _hasExceptions = false;

  @computed
  bool get hasExceptions => _hasExceptions;

  @observable
  String? _errorMsg;

  @computed
  String? get errorMsg => _errorMsg;

  @action
  putLoading(bool value) {
    isLoading = value;
  }

  @action
  putWishlistCount(int count) {
    _wishlistCount = count;
  }

  @action
  getWishlistData(BuildContext context) async {
    putLoading(true);
    print(isLoading);
    final client = GraphQLProvider.of(context);
    var result = await client.value.query(QueryOptions(document: gql(CustomerApis.wishList)));
    print("exception ${result.hasException}");
    print(result);
    if (result.hasException) {
      _hasExceptions = true;
      try {
        _errorMsg = result.exception!.graphqlErrors[0].message;
      } catch (e) {
        try {
          _errorMsg = result.exception!.linkException!.originalException.toString();
        } catch (e) {
          _errorMsg = "An error occured. Please try after some time";
        }
      }
      return;
    }
    _wishlist = Wishlist();
    _wishlist = Wishlist.fromJson(result.data!['wishlist']);
    putLoading(false);
  }
}
