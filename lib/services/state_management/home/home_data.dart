import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart' hide Store;
import 'package:m2/services/api_services/api_services.dart';
import 'package:mobx/mobx.dart';
part 'home_data.g.dart';

class HomeData = _HomeDataBase with _$HomeData;

abstract class _HomeDataBase with Store {
  @observable
  Map<String, dynamic> _data = {};
  Map<String, dynamic> get data => _data;

  @observable
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @action
  void setLoading(bool value) => _isLoading = value;

  @action
  getHomeData(BuildContext context) async {
    setLoading(true);
    var graphqlClient = GraphQLProvider.of(context);
    QueryResult? result = await graphqlClient.value.query(WatchQueryOptions(document: gql(ApiServices.getCategories)));
    _data = result.data!;
    setLoading(false);
  }
}
