import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart' hide Store;
import 'package:m2/services/api_services/api_services.dart';
import 'package:mobx/mobx.dart';
part 'categories_data.g.dart';

// ignore: library_private_types_in_public_api
class CategoriesData = _CategoriesDataBase with _$CategoriesData;

abstract class _CategoriesDataBase with Store {
  @observable
  Map<String, dynamic> _data = {};
  Map<String, dynamic> get data => _data;

  @observable
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @observable
  List<bool> _portalTargets = [];
  List<bool> get portalTargets => _portalTargets;

  @action
  void populateTargets() {
    _portalTargets = List.generate(data['categories']['items'][0]['children'].length, (index) => false);
  }

  @action
  void editTargets(int index) {
    populateTargets();
    portalTargets[index] = true;
  }

  @action
  void setLoading(bool value) => _isLoading = value;

  @action
  getCategoryData(BuildContext context) async {
    setLoading(true);
    var graphqlClient = GraphQLProvider.of(context);
    QueryResult? result = await graphqlClient.value.query(WatchQueryOptions(document: gql(ApiServices.getCategories)));
    // print(result.data);
    _data = result.data!;
    setLoading(false);
  }
}
