import 'package:m2/services/api_services/api_services.dart';
import 'package:m2/services/api_services/customer_apis.dart';
import 'package:m2/services/models/user.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart' hide Store;
import 'package:provider/provider.dart';
part 'user_data.g.dart';

class UserData = _UserDataBase with _$UserData;

abstract class _UserDataBase with Store {
  @observable
  User _data = User();
  User get data => _data;

  @observable
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @action
  void setLoading(bool value) => _isLoading = value;

  @action
  Future<bool> getUserData(BuildContext context) async {
    setLoading(true);
    var graphqlClient = GraphQLProvider.of(context);
    QueryResult? result = await graphqlClient.value.query(WatchQueryOptions(document: gql(CustomerApis.requestUserData)));
    if (result.hasException) {
      setLoading(false);
      return false;
    } else {
      _data = User.fromJson(result.data!['customer']);
    }
    setLoading(false);
    return true;
  }

  @action
  clearUserData() {
    // _data.clear();
  }
}
