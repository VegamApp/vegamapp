import 'package:graphql_flutter/graphql_flutter.dart';

class Fragments {
  static final cartFragment = gql('''
  fragment CartFragment on Cart {
  id
  email
  total_quantity
  gift_message {
    from
    to
    message
    __typename
  }
  applied_coupons {
    code
    __typename
  }
  available_payment_methods {
    code
    title
    __typename
  }
  selected_payment_method {
    code
    purchase_order_number
    title
    __typename
  }
  shipping_addresses {
    firstname
    lastname
    city
    street
    customer_notes
    customer_address_id
    house_name
    locations
    landmark
    country {
      code
      label
      __typename
    }
    region {
      label
      region_id
      code
      __typename
    }
    postcode
    telephone
    selected_shipping_method {
      amount {
        value
        __typename
      }
      note
      carrier_code
      carrier_title
      method_title
      method_code
      __typename
    }
    available_shipping_methods {
      amount {
        value
        currency
        __typename
      }
      note
      available
      carrier_code
      carrier_title
      error_message
      method_title
      method_code
      __typename
    }
    __typename
  }
  billing_address {
    firstname
    lastname
    city
    street
    house_name
    customer_address_id
    locations
    landmark
    country {
      code
      label
      __typename
    }
    region {
      label
      region_id
      code
      __typename
    }
    postcode
    telephone
    __typename
  }
  prices {
    grand_total {
      value
      __typename
    }
    subtotal_including_tax {
      value
      __typename
    }
    subtotal_with_discount_excluding_tax {
      value
      __typename
    }
    applied_taxes {
      amount {
        value
        __typename
      }
      label
      __typename
    }
    discounts {
      label
      amount {
        value
        __typename
      }
      __typename
    }
    __typename
  }
  items {
    uid
    quantity
    salable_qty
    is_salable
    error
    ... on SimpleCartItem {
      gift_message {
        from
        to
        message
        __typename
      }
      __typename
    }
    prices {
      price {
        value
        __typename
      }
      row_total {
        value
        __typename
      }
      total_item_discount {
        value
        __typename
      }
      __typename
    }
    product {
      uid
      gift_message_available
      name
      sku
      url_key
      url_suffix
      product_inventory {
        is_qty_decimal
        min_sale_qty
        qty_increments
        enable_qty_increments
        max_sale_qty
        __typename
      }
      price_range {
        maximum_price {
          regular_price {
            value
            __typename
          }
          final_price {
            value
            __typename
          }
          __typename
        }
        __typename
      }
      thumbnail {
        url
        label
        __typename
      }
      __typename
    }
    __typename
  }
  __typename
}
''');
}
