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

  static String requestUserData = '''
  {
    customer {
      firstname
      lastname
      suffix
      email
      gender
      is_subscribed
      wishlist{
        id
      }
      addresses {
        id
        firstname
        lastname
        street
        city
        region {
          region_code
          region
        }
        postcode
        country_code
        telephone
      }
    }
  }
''';

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
