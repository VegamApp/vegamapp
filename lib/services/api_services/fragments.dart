import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/utilities/constants.dart';

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
      is_deferred
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

  static final Customer = addFragments(gql(r'''
  fragment Customer on Customer {
    orders {
      items {
        number
        total {
          grand_total {
            value
            __typename
          }
          __typename
        }
        shipping_address {
          firstname
          lastname
          city
          street
          region
          country_code
          __typename
        }
        billing_address {
          firstname
          lastname
          city
          street
          region
          country_code
          __typename
        }
        order_date
        order_number
        items {
          product_sale_price {
            value
            __typename
          }
          id
          product_url_key
          product_sku
          quantity_ordered
          product_name
          __typename
        }
        shipping_method
        status
        payment_methods {
          name
          __typename
        }
        __typename
      }
      total_count
      page_info {
        page_size
        total_pages
        current_page
        __typename
      }
      __typename
    }
    addresses {
      ...CAddress
      __typename
    }
    compare_list {
      attributes {
        code
        __typename
      }
      item_count
      uid
      items {
        uid
        product {
          image {
            label
            url
            __typename
          }
          description {
            html
            __typename
          }
          short_description {
            html
            __typename
          }
          sku
          name
          price_range {
            maximum_price {
              final_price {
                currency
                value
                __typename
              }
              __typename
            }
            minimum_price {
              final_price {
                value
                __typename
              }
              __typename
            }
            __typename
          }
          __typename
        }
        __typename
      }
      uid
      __typename
    }
    wishlists {
      id
      items_count
    }

    allow_remote_shopping_assistance
    created_at
    date_of_birth
    default_billing
    default_shipping
    email
    firstname
    gender
    is_subscribed
    lastname
    middlename
    prefix
    suffix
    taxvat
    #mobilenumber
    reviews {
      __typename
      items {
        average_rating
        created_at
        text
        product {
          sku
          name
          __typename
        }
        __typename
      }
    }
    __typename
  }
  '''), [CAddress]);
  static final CAddress = gql(r'''
  fragment CAddress on CustomerAddress {
    city
    company
    country_code
    default_billing
    default_shipping
    extension_attributes {
      attribute_code
      value
      __typename
    }
    fax
    firstname
    id
    lastname
    middlename
    postcode
    prefix
    region {
      region
      region_code
      region_id
      __typename
    }
    street
    suffix
    telephone
    __typename
  }''');
}
