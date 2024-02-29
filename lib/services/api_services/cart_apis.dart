import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/fragments.dart';
import 'package:m2/utilities/utilities.dart';

class CartApis {
  // Cart query
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
    items {
      id
      product {
        name
        sku
        url_key
        url_suffix
        image{
          url
        }
        stock_status
        special_price
        price_range{
          minimum_price{
            regular_price{
              value
              currency
            }
          }
          maximum_price {
            regular_price {
              value
              currency
            }
            discount {
                amount_off
                percent_off
            }
          }
        }
      }
      quantity
    }
      
    ...Prices
    ...SelectedPaymentMethod
    ...ShippingAddresses
    total_quantity
    __typename
  }
}'''), [
    //All fragments used here
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
          name
          sku
          url_key
          url_suffix
          image{
            url
          }
          stock_status
          special_price
          price_range{
            minimum_price{
              regular_price{
                value
                currency
              }
            }
            maximum_price {
              regular_price {
                value
                currency
              }
              discount {
                  amount_off
                  percent_off
              }
            }
          }
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
  static String applyCouponToCart = r'''mutation applyCouponToCart($cartID: String!, $couponCode: String!){
  applyCouponToCart(input: { cart_id: $cartID, coupon_code: $couponCode }) {
    cart {
      total_quantity
    }
  }
}
''';
  static String removeCouponFromCart = r'''
mutation removeCouponFromCart($cartId:String!) {
  removeCouponFromCart(input: { cart_id: $cartId }) {
    cart {

      total_quantity
    }
  }
}
''';

  static String updateCart = r'''
    mutation updateCartItems($input: UpdateCartItemsInput){
      updateCartItems(
        input: $input
      ){
        cart {
          items {
            uid
            product {
              name
            }
            quantity
          }
          prices {
            grand_total{
              value
              currency
            }
          }
        }
      }
    }''';

  static String setShippingAddressesOnCart = r'''
  mutation setShippingAddressesOnCart($input: SetShippingAddressesOnCartInput){
    setShippingAddressesOnCart(input:$input) {
      cart {
        shipping_addresses {
          firstname
          lastname
          company
          street
          city
          region {
            code
            label
          }
          postcode
          telephone
          country {
            code
            label
          }
          available_shipping_methods{
            carrier_code
            carrier_title
            method_code
            method_title
          }
        }
      }
    }
  }
  ''';
  static String setBillingAddressesOnCart = r'''
  mutation setBillingAddressOnCart($input:SetBillingAddressOnCartInput){
    setBillingAddressOnCart(input: $input) {
      cart {
        billing_address {
          firstname
          lastname
          company
          street
          city
        }
      }
    }
  }
  ''';

  static String setEmailOnGuestCart = r'''
  mutation setGuestEmailOnCart($cart_id:String!, $email: String!){
    setGuestEmailOnCart(input: { cart_id: $cart_id, email: $email }) {
      cart {
        total_quantity
      }
    }
  }
  ''';

  static String setPaymentMethodOnCart = r'''
  mutation setPaymentMethodOnCart($cartId:String!, $paymentMethod:PaymentMethodInput! ){
    setPaymentMethodOnCart(input: {
        cart_id: $cartId
        payment_method: $paymentMethod
    }) {
      cart {
        selected_payment_method {
          code
        }
      }
    }
  }''';

  static String setShippingMethod = r'''
  mutation setShippingMethodsOnCart($cartId: String!, $shippingMethod: [ShippingMethodInput!]!){
    setShippingMethodsOnCart(
      input: { cart_id: $cartId, shipping_methods: $shippingMethod }
    ) {
      cart {
        email
    
      }
    }
  }
  ''';

  static String removeProductsFromCart = r'''
    mutation removeItemFromCart($cartId: String!,$itemId: Int!){
      removeItemFromCart(input: { cart_id: $cartId ,cart_item_id:$itemId}) {
        cart {
          
          total_quantity
        }
      }
    }
    ''';
}
