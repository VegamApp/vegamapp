import 'package:mobx/mobx.dart';
part 'token.g.dart';

class AuthToken = _AuthTokenBase with _$AuthToken;

abstract class _AuthTokenBase with Store {
  @observable
  String? _loginToken;
  String? get loginToken => _loginToken;

  @observable
  String? _cartId;
  String? get cartId => _cartId;

  @observable
  int _cartCount = 0;
  int get cartCount => _cartCount;

  @observable
  int _wishlistCount = 0;
  int get wishlistCount => _wishlistCount;

  @action
  putWishlistCount(int count) {
    _wishlistCount = count;
  }

  @action
  putLoginToken(String token) {
    _loginToken = token;
  }

  @action
  clearLoginToken() {
    _loginToken = null;
  }

  printToken() {
    //print(loginToken);
  }

  @action
  putCartCount(int count) {
    _cartCount = count;
  }

  @action
  putCartId(String newCartId) {
    _cartId = newCartId;
  }

  clearCartId() {
    _cartId = null;
  }
}
