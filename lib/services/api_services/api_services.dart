import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/fragments.dart';
import 'package:m2/services/models/search_model.dart';
import 'package:m2/utilities/utilities.dart';

class ApiServices {
  static Map<String, String> header = {'Content-Type': 'application/json'};
  static String? storeName;
  static String? pinCode;
  // static String baseUrl = 'https://kalyan.ceymox.info/graphql';
  // static String baseUrl = 'https://kalyanhyper.pwa.ceymox.xyz/api/graphql';

  static String domain = 'https://flutter.ceymox.net/';
  static String path = '$domain/graphql/';

  static final cart = addFragments(gql(r'''
  query getCart($id: String!) {
  cart(cart_id: $id) {
     ...AppliedCoupons
    ...AvailablePaymentMethod
    ...BillingAddress
    email
    ...GiftMessage
    id
    is_virtual
    items{
      product{
        name
      }
    }
    ...Prices
    ...SelectedPaymentMethod
    ...ShippingAddresses
    total_quantity
    __typename
  }
}'''), [
    Fragments.appliedCouponFragment,
    Fragments.availablePaymentMethodFragment,
    Fragments.billingAddressFragment,
    Fragments.giftMessageFragment,
    Fragments.pricesFragment,
    Fragments.selectedPaymentMethodFragment,
    Fragments.shippingAddressesFragment
  ]);

  static String getCategories = r'''
query getCategories($filter: CategoryFilterInput, $pagesize: Int, $page: Int) {
  categories(filters: $filter, pageSize: $pagesize, currentPage: $page) {
    items {
      name
      url_path
      children {
        name
        include_in_menu
        url_key
        url_path
        uid
        children {
          name
          uid
          id
          include_in_menu
          url_key
          url_path
          __typename
        }
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  static final searchSuggession = gql(r'''
 query Products($searchQuery: String!){   
   products(search: $searchQuery, pageSize: 5) {
     total_count
     items {
        name
        sku
        image {
          url          
          label        
        }
     }
   }
 }''');

  Future<List<SearchModel>> searchSuggessionApi({required searchQuery, required BuildContext context}) async {
    var graphqlClient = GraphQLProvider.of(context);
    QueryResult? result = await graphqlClient.value.query(WatchQueryOptions(document: searchSuggession, variables: {"searchQuery": searchQuery}));
    List<SearchModel> searchModelList = [];
    if (result.data != null) {
      try {
        searchModelList = List<SearchModel>.generate(
          result.data!['products']['items'].length,
          (index) => SearchModel.fromJson(result.data!['products']['items'][index]),
        );
        return searchModelList;
      } catch (e) {
        print(e);
      }
    }
    return [];
  }
}
