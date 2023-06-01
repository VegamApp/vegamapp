class PaymentServices {
  static String getAvailablePaymentMethods(String cartId) => '''
  {
    cart(cart_id: "$cartId") {
      available_payment_methods {
        code
        title
      }
      selected_payment_method {
        code
        title
      }
      applied_coupons {
        code
      }
      prices {
        grand_total {
          value
          currency
        }
      }
    }
  }  ''';
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

  static String placeRazorPayOrder = r'''
 mutation placeRazorPayOrder($cartId: String!) {
  placeRazorpayOrder(cart_id: $cartId) {
    amount
    currency
    message
    order_quote_id
    rzp_order_id
    success
    __typename
  }
}''';

  static String placeOrder = r'''
mutation ($cartId: String!){
  placeOrder(input: { cart_id: $cartId }) {
    order {
      order_number
    }
  }
}
''';

  static String setRazorOnCart = r'''
  mutation SetRzpPaymentDetailsOnCart($input: SetRzpPaymentDetailsOnCartInput!){
    setRzpPaymentDetailsOnCart(
      input: $input
    ) {
      cart {
        id
        total_quantity
      }
    }
  }
''';
}
