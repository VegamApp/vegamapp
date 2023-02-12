import 'package:graphql_flutter/graphql_flutter.dart';

class Fragments {
//   static final cartFragment = gql('''
//   fragment CartFragment on Cart {

//   }
// ''');

  static final appliedCouponFragment = gql('''
  fragment AppliedCoupons on Cart {
    applied_coupons {
      code
    }
  }''');

  static final availablePaymentMethodFragment = gql('''
  fragment AvailablePaymentMethod on Cart {
    available_payment_methods {
      code
      title
    }
  }''');

  static final billingAddressFragment = gql('''
  fragment BillingAddress on Cart {
    billing_address {
      city
      company
      country {
        code
        label
      }
      firstname
      lastname
      postcode
      region {
        code
        label
        region_id
      }
      street
      telephone
    }
  }''');

  static final giftMessageFragment = gql('''
  fragment GiftMessage on Cart {
    gift_message {
      from
      message
      to
    }
  }''');

  static final pricesFragment = gql('''
  fragment Prices on Cart {
    prices {
      applied_taxes {
      amount{
        value
        currency
      }
        label
      }
      
      discounts {
        amount{
          value
          currency
        }
        label
      }
      grand_total {
        currency
        value
      }
      subtotal_excluding_tax {
        currency
        value
      }
      subtotal_including_tax {
        currency
        value
      }
      subtotal_with_discount_excluding_tax {
        currency
        value
      }
    }
}''');

  static final shippingAddressesFragment = gql('''
  fragment ShippingAddresses on Cart {
    shipping_addresses {
      customer_notes
      firstname
      lastname
      pickup_location_code
      postcode
      street
      telephone
      region {
        code
        label
        region_id
      }
      selected_shipping_method {
        amount{
          value
          currency
        }
        carrier_code
        carrier_title
        method_code
        method_title
      }
      available_shipping_methods {
        amount{
          value
          currency
        }
        available
        carrier_code
        carrier_title
        error_message
        method_code
        method_title
        price_excl_tax{
          value
          currency
        }
        price_incl_tax{
          value
          currency
        }
      }
      city
      company
      country {
        code
        label
      }
    }
}''');

  static final selectedPaymentMethodFragment = gql('''
  fragment SelectedPaymentMethod on Cart {
    selected_payment_method {
      code
      purchase_order_number
      title
    }
}''');
}
