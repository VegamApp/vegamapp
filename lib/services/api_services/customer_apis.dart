import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/fragments.dart';
import 'package:m2/utilities/utilities.dart';

class CustomerApis {
  static String signInWithEmail = r'''
    mutation SignInWithEmail($email:String!, $password: String!){
      generateCustomerToken(email: $email,password: $password) {
        token
      }
    }
  ''';

  static String signUpWithEmail = r'''
    mutation  SignUp($firstname: String!,$lastname: String!,$email: String!,$password: String!,$date_of_birth: String,$gender: Int,$is_subscribed: Boolean){
      createCustomerV2(
        input: {
        firstname: $firstname
          lastname: $lastname
          email: $email
          password: $password
          date_of_birth:$date_of_birth
          gender:$gender
          is_subscribed:$is_subscribed
        }
      ) {
        customer {
        firstname
        lastname
        email
        date_of_birth
        gender
        is_subscribed
        }
      }
    }''';

  static String requestPasswordResetEmail = r'''
    mutation resetPasswordEmail($email: String!){
      requestPasswordResetEmail(
        email: $email
      )
    }
  ''';
  static String wishList = '''
  {
    wishlist {
      items_count
      sharing_code
      updated_at
      items {
        id
        qty
        description
        added_at
        product{
          __typename
          name
          sku
          url_key
          size_chart
          rating_summary
          review_count
          stock_status
          image{
            url
          }
          special_price
          price_range {
            minimum_price {
              regular_price {
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
          ... on CustomizableProductInterface {
            options {
              title
              required
              sort_order
              option_id
              uid
              ... on CustomizableDropDownOption {
                value {
                  option_type_id
                  price
                  price_type
                  sku
                  sort_order
                  title
                  uid
                }
              }
            }
          }
          ... on ConfigurableProduct {
            configurable_options {
              id
              label
              position
              use_default
              attribute_code
              values {
                store_label
                store_label
                label
                uid
                swatch_data {
                  value
                }
              }
            }
            variants {
              product {
                name
                sku
                id
                media_gallery {
                  url
                  label
                }
                special_price
                price_range {
                  minimum_price {
                    regular_price {
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
              attributes {
                label
                code
                value_index
                uid
              }
            }
          }
        }
      }
    }
  }''';
  static final requestUserData = addFragments(gql(r'''
  query GetCustomer($showWishlist: Boolean = true) {
  customer {
    ...Customer
    __typename
  }
}
'''), [Fragments.Customer]);

  static String updateCustomer = r'''
    mutation updateCustomerV2($input: CustomerUpdateInput!) {
      updateCustomerV2(input: $input) 
      {
        customer {
        firstname
        lastname
        gender
        }
      }
    }
  ''';

  static String orderDetails = r'''
    query Orders($page:Int!){
      customer {
        orders(currentPage: $page, pageSize:10){
            items {
            number
            id
            order_date
            status
            total{
              grand_total{
                value
              }
            }
            items{
              product_name
              status
              product_sku
              quantity_ordered
              product_sale_price{
                  value
              }
              
            }
            status
          }
          page_info {
          current_page
          page_size
          total_pages
        }
        }
      }
    }
  ''';

  static String createCustomerAddress = r'''
  mutation createCustomerAddress($street:[String], $telephone:String, $postcode:String, $city:String, $firstname:String!, $lastname:String!, $default_shipping: Boolean, $default_billing: Boolean){
    createCustomerAddress(input: {
      region: {
        region: "California"
        region_code: "CA"
        region_id: 12
      }
      country_code: US
      street: $street
      telephone: $telephone
      postcode: $postcode
      city: $city
      firstname: $firstname
      lastname: $lastname
      default_shipping: $default_shipping
      default_billing: $default_billing
    }) {
      id
      region {
        region
        region_code
      }
      country_code
      street
      telephone
      postcode
      city
      default_shipping
      default_billing
    }
  }
''';
}
