// Queries related to payment are listed here.
class PaymentServices {
  // Available payment methods on cart
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

  static String placeOrder = r'''
  mutation ($cartId: String!){
    placeOrder(input: { cart_id: $cartId }) {
      order {
        order_number
      }
    }
  }
  ''';
  static String placeRazorpayOrder = r'''
  mutation placeRazorpayOrder($id: String!){
    placeRazorpayOrder (
        order_id: $id
        referrer: "www.m2.festa.wiki"
    ){
      success
      rzp_order_id
      order_id
      amount
      currency
      message
    }
  }''';
  static String setRzpPaymentDetailsForOrder = r'''
  mutation setRzpPaymentDetailsForOrder($input: SetRzpPaymentDetailsForOrderInput!){
    setRzpPaymentDetailsForOrder(input:$input){
      order{
        order_id
      }
    }
  }''';

  static String resetCart = r'''mutation resetCart($id: String!){
  resetCart(order_id: $id){
      success
    }
  }''';

  static String createBraintreeClientToken = r'''mutation { createBraintreeClientToken }''';
}
