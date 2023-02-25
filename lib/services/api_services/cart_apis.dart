import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/fragments.dart';
import 'package:m2/utilities/utilities.dart';

class CartApis {
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

  static String addProductToCart = r'''
  mutation addProductsToCart($cartIdString: String!,$cartItemsMap:[CartItemInput!]!){
    addProductsToCart(
     cartId: $cartIdString
     cartItems: $cartItemsMap
  ) {
    cart {
      items {
        id
        product {
          sku
          stock_status
        }
        quantity
      }
      
      total_quantity
    }
    user_errors {
      code
      message
    }
  }
  }''';

  static String mergeCart = r'''
    mutation MergeCarts($oldCart: String!,$newCart: String!){
      mergeCarts(source_cart_id: $oldCart, destination_cart_id: $newCart) {
        id
        total_quantity
      }
    }
  ''';
}
