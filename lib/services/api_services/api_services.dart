import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/fragments.dart';
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
}
