import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/fragments.dart';

class ApiServices {
  static Map<String, String> header = {'Content-Type': 'application/json'};
  static String? storeName;
  static String? pinCode;
  // static String baseUrl = 'https://kalyan.ceymox.info/graphql';
  // static String baseUrl = 'https://kalyanhyper.pwa.ceymox.xyz/api/graphql';

  static String domain = 'https://flutter.ceymox.net/';
  static String path = '$domain/graphql/';

  static final cart = gql(r'''
  query getCart($id: String!) {
  cart(cart_id: $id) {
    ...CartFragment
    __typename
  }
}''').definitions.addAll(Fragments.cartFragment.definitions);
}
