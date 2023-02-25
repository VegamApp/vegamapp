class CustomerApis {
  static String signInWithEmail = r'''
    mutation SignInWithEmail($email:String!, $password: String!){
      generateCustomerToken(email: $email,password: $password) {
        token
      }
    }
  ''';

  static String signUpWithEmail = r'''
    mutation  SignUp($firstname: String!,$lastname: String!,$email: String!,$password: String!,$date_of_birth: String!,$gender: Int!,$is_subscribed: Boolean!){
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
}
