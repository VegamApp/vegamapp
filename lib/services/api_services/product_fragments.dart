import 'package:graphql_flutter/graphql_flutter.dart';

class ProductFragments {
  static final productInterfaceFields = gql(r'''

fragment ProductInterfaceFields on ProductInterface {
  name
  sku
}
''');

  static final productImageFields = gql(r'''
fragment ProductImageFields on ProductImage {
  url
}
''');

  static final categoryInterfaceFields = gql(r'''
fragment CategoryInterfaceFields on CategoryInterface {
  name
  uid
}
''');

  static final complexTextValueFields = gql(r'''
fragment ComplexTextValueFields on ComplexTextValue {
  html
}
''');

  static final moneyFields = gql(r'''
fragment MoneyFields on Money {
  value
  currency
}
''');

  static final productDiscountFields = gql(r'''
fragment ProductDiscountFields on ProductDiscount {
  amount_off
  percent_off
}
''');

  static final configurableProductOptionsFields = gql(r'''
fragment ConfigurableProductOptionsFields on ConfigurableProductOptions {
  id
  attribute_id_v2
  label
  position
  use_default
  attribute_code
  product_id
}
''');

  static final configurableProductOptionsValuesFields = gql(r'''
fragment ConfigurableProductOptionsValuesFields on ConfigurableProductOptionsValues {
  uid
  value_index
  label
}
''');

  static final swatchDataInterfaceFields = gql(r'''
fragment SwatchDataInterfaceFields on SwatchDataInterface {
  value
}
''');

  static final simpleProductFields = gql(r'''
fragment SimpleProductFields on SimpleProduct {
  id
  name
  sku
  attribute_set_id
}
''');

  static final mediaGalleryInterfaceFields = gql(r'''
fragment MediaGalleryInterfaceFields on MediaGalleryInterface {
  url
  label
}
''');

  static final configurableAttributeOptionFields = gql(r'''
fragment ConfigurableAttributeOptionFields on ConfigurableAttributeOption {
  uid
  label
  code
  value_index
}
''');
}
