import 'package:mobx/mobx.dart';
part 'token.g.dart';

class AuthToken = _AuthTokenBase with _$AuthToken;

abstract class _AuthTokenBase with Store {
  _AuthTokenBase(this._loginToken);

  @observable
  String? _loginToken;
  String? get loginToken => _loginToken;

  @observable
  int _wishlistCount = 0;
  int get wishlistCount => _wishlistCount;

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
}
