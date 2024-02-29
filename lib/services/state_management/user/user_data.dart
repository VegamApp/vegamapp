
import 'package:m2/services/api_services/customer_apis.dart';
import 'package:m2/services/models/user.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart' hide Store;
part 'user_data.g.dart';

class UserData = _UserDataBase with _$UserData;

abstract class _UserDataBase with Store {
  @observable
  User _data = User();
  User get data => _data;

  @observable
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @observable
  ObservableList<Addresses> addressesList = ObservableList<Addresses>();

  @action
  void setLoading(bool value) => _isLoading = value;

  @action
  putData(User data) {
    _data = data;
  }

  @action
  Future<bool> getUserData(BuildContext context) async {
    setLoading(true);
    var graphqlClient = GraphQLProvider.of(context);
    QueryResult? result = await graphqlClient.value.query(WatchQueryOptions(document: CustomerApis.requestUserData));
    // log(result.toString());
    // log(jsonEncode(result.data));
    if (result.hasException) {
      setLoading(false);
      return false;
    } else {
      addressesList.clear();
      _data = User.fromJson(result.data!['customer']);
      addressesList.addAll(ObservableList<Addresses>.of(_data.addresses ?? <Addresses>[]));
    }
    setLoading(false);
    return true;
  }

  @action
  clearUserData() {
    // _data.clear();
  }
  @action
  removeAddress(Addresses address) {
    addressesList.removeWhere((element) => element == address);
  }
}
