import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/fragments.dart';
import 'package:m2/utilities/utilities.dart';

//Customer api's including auth api's query and mutations are listed here
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
          name
          sku
          url_key
          url_suffix
          image {
            url
          }
          stock_status
          #wishlistData{
          #  wishlistItem
          #}
          __typename
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
          ... on ConfigurableProduct {
            configurable_options {
              id
              attribute_id_v2
              label
              position
              use_default
              attribute_code
              values {
                uid
                value_index
                label
                swatch_data {
                  value
                }
              }
              product_id
            }
            variants {
              product {
                id
                name
                sku
                attribute_set_id
                media_gallery {
                  url
                  label
                }
                ... on PhysicalProductInterface {
                  weight
                }

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
                uid
                label
                code
                value_index
              }
            }
          }
        }
      }
    }
  }''';
  static final requestUserData = addFragments(gql(r'''
{
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
  static final updateCustomerAddress = addFragments(gql(r'''
    mutation updateCustomerAddress($addressId: Int!, $input: CustomerAddressInput!) {
      updateCustomerAddress(id: $addressId, input: $input) {
      ...CAddress
      }
    }'''), [Fragments.CAddress]);

  static final deleteCustomerAddress = gql(r'''
    mutation deleteAddress($id: Int!){
      deleteCustomerAddress(id: $id)
    }
  ''');

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
