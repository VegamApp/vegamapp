import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart' hide Store;
import 'package:m2/services/api_services/api_services.dart';
import 'package:mobx/mobx.dart';
part 'home_data.g.dart';

class HomeData = _HomeDataBase with _$HomeData;

abstract class _HomeDataBase with Store {
  @observable
  Map<String, dynamic> _data = {};

  @computed
  Map<String, dynamic> get data => _data;

  @observable
  bool _isLoading = false;

  @computed
  bool get isLoading => _isLoading;

  @observable
  double _homeCarouselAspectRatio = 0.77;

  @computed
  double get homeCarouselAspectRatio => _homeCarouselAspectRatio;

  @action
  putAspectRatio(double aspectRatio) {
    _homeCarouselAspectRatio = aspectRatio;
  }

  @action
  void setLoading(bool value) => _isLoading = value;

  @action
  getHomeData(BuildContext context) async {
    setLoading(true);
    var client = GraphQLProvider.of(context);
    QueryResult? result = await client.value.query(WatchQueryOptions(document: gql(ApiServices.queryHome)));
    // print(result);
    log(jsonEncode(result.data));
    _data = result.data!;
    setLoading(false);
  }
}
