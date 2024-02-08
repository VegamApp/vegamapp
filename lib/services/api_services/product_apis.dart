class ProductApi {
  static String products = r'''
  query products(
  $pageSize: Int!
  $page: Int!
  $filter: ProductAttributeFilterInput!
  $searchQuery: String
) {
  products(
    search: $searchQuery
    filter: $filter
    pageSize: $pageSize
    currentPage: $page
  ) {
    aggregations(filter: { category: { includeDirectChildrenOnly: true } }) {
      attribute_code
      count
      label
      options {
        label
        value
        count
      }
    }
    items {
      name
      sku
      url_key
      url_suffix
      image {
        url
      }
      rating_summary
      review_count
      stock_status

      categories {
        name
        uid
        path
      }
      ... on PhysicalProductInterface {
        weight
      }
      # wishlistData{
      #   wishlistItem
      # }
      description {
        html
      }
      short_description {
        html
      }
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
      categories {
        uid
        name
      }
      ... on SimpleProduct {
        options {
          title
          required
          sort_order
          option_id
          ... on CustomizableDropDownOption {
            value {
              option_type_id
              uid
              price
              price_type
              sku
              sort_order
              title
            }
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
      ... on BundleProduct {
        description {
          html
        }
        dynamic_price
        dynamic_sku
        items {
          option_id
          options {
            can_change_quantity
            id
            is_default
            label
            position
            price
            price_type
            product {
              name
              url_key
              sku
              attribute_set_id
              media_gallery {
                url
                label
              }
            }
            quantity
            uid
          }
          position
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
          required
          sku
          title
          type
          uid
        }
      }
      media_gallery {
        url
        label
        ... on ProductVideo {
          video_content {
            media_type
            video_provider
            video_url
            video_title
            video_description
            video_metadata
          }
        }
      }
      related_products {
        name
        sku
        url_key
        url_suffix
        image {
          url
        }
        rating_summary
        review_count
        stock_status

        categories {
          name
          uid
          path
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
        # product_inventory{
        #   enable_qty_increments
        #   is_qty_decimal
        #   max_sale_qty
        #   min_sale_qty
        #   qty_increments
        # }
      }
    }
    sort_fields {
      default
      options {
        label
        value
      }
    }
    page_info {
      current_page
      page_size
      total_pages
    }
  }
}
''';

  static String viewAllProduct = r'''
  query viewallProducts($pageSize: Int!, $page: Int!,$id: Int!)
{
  viewallProducts(
    input:{Id:$id},
    pageSize:$pageSize,
    currentPage:$page
  ) 
  {
    products {
      name
      sku
      url_key
      url_suffix
      image{
        url
      }
      rating_summary
      review_count
      stock_status
      
      categories{
        name
        uid
        path
      }
      ... on PhysicalProductInterface{
        weight
      }
      # wishlistData{
      #   wishlistItem
      # }
      description {
        html
      }
      short_description	{
        html
      }
      __typename
      special_price
      price_range{
        minimum_price{
          regular_price{
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
      categories {
        uid
        name
      }
    }
    total_count
  }
}''';

  static String createReview = r'''
mutation createProductReview($name:String!, $sku: String!, $summary: String!, $text:String!, $ratings: [ProductReviewRatingInput]!){
  createProductReview(
    input: {
      nickname: $name
      ratings: $ratings
      sku: $sku
      summary: $summary
      text: $text
    }
  ) {
    review {
      average_rating
      created_at
      nickname
      summary
      text
    }
  }
}
''';

  static String reorder = r'''
  mutation ReorderItems($orderNo: String!){
    reorderItems(orderNumber: $orderNo) {
      cart {
        total_quantity
      }
      userInputErrors {
        code
        message
        path
      }
    }
  }
  ''';
}
