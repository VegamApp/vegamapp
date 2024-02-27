import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart' hide Store;
import 'package:mobx/mobx.dart';
part 'cache_manager.g.dart';

class CacheManager = _CacheManagerBase with _$CacheManager;

abstract class _CacheManagerBase with Store {
  @observable
  int i = 0;

  @action
  increment() {
    i++;
  }

  @action
  reset() {
    i = 0;
  }

  @action
  checkCache(BuildContext context) {
    print("Checking cache...");

    if (i < 15) {
      increment();
      return;
    }
    reset();
    print("cache cleared");
    var client = GraphQLProvider.of(context);
    client.value.cache.store.reset();
  }
}
