import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/models/search_model.dart';

class ApiServices {
  static Map<String, String> header = {'Content-Type': 'application/json'};
  static String? storeName;
  static String? pinCode;
  // static String baseUrl = 'https://kalyan.ceymox.info/graphql';
  // static String baseUrl = 'https://kalyanhyper.pwa.ceymox.xyz/api/graphql';

  static String domain = 'https://flutter.ceymox.net/';
  static String path = '$domain/graphql/';

  static String getCategories = r'''
query getCategories($filter: CategoryFilterInput, $pagesize: Int, $page: Int) {
  categories(filters: $filter, pageSize: $pagesize, currentPage: $page) {
    items {
      name
      url_path
      children {
        name
        include_in_menu
        url_key
        url_path
        url_suffix
        uid
        children {
          name
          uid
          id
          include_in_menu
          url_key
          url_path
          url_suffix
          __typename
        }
        __typename
      }
      __typename
    }
    __typename
  }
}
''';

  static final searchSuggession = gql(r'''
 query Products($searchQuery: String!){   
   products(search: $searchQuery, pageSize: 5) {
     total_count
     items {
        name
        sku
        url_key
        url_suffix
        image {
          url          
          label        
        }
     }
   }
 }''');

  Future<List<SearchModel>> searchSuggessionApi({required searchQuery, required BuildContext context}) async {
    var graphqlClient = GraphQLProvider.of(context);
    QueryResult? result = await graphqlClient.value.query(WatchQueryOptions(document: searchSuggession, variables: {"searchQuery": searchQuery}));
    List<SearchModel> searchModelList = [];
    if (result.data != null) {
      try {
        searchModelList = List<SearchModel>.generate(
          result.data!['products']['items'].length,
          (index) => SearchModel.fromJson(result.data!['products']['items'][index]),
        );
        return searchModelList;
      } catch (e) {
        print(e);
      }
    }
    return [];
  }

  static String queryHome = '''
  {
    homepage{
      blocks{
        data{
          status
          mobile_status
          name
          store
          store_label
          show_title
          __typename
          ... on SliderBlock{
            autoplay
            autoplay_hover_pause
            autoplay_timeout
            banners{
              image
              layout
              link
              position
              title
              link_info {
                  category_id
                  external_url
                  link_type
                  link_url
                  open_tab
                  page_id
                  product_id
                  product_sku
                }  
            }
            mobile_status
            name
            show_dots
            templateType
            slider_width
            sliders{
              description
              start_date
              end_date
              position
              link{
                category_id
                external_url
                link_type
                link_url
                page_id
                product_id
                product_sku  
              }
                slider_image
              }
            store
            store_label
            templateType
          }
          ...on BannerBlock{
            banneritems{
              image
              layout
              link
                link_info{
                  category_id
                  external_url
                  link_type
                  link_url
                  page_id
                  product_id
                  product_sku
                  open_tab
                }
              position
              title
            }
            banner_template
            }
          ...on CategoryBlock{
            category_info{
              name
              category_id
              url_path
              url_key
              image
            }
          }
          ...on ContentBlock{
            content
            mobile_status
            name
            store
            store_label
          }
          ...on ProductBlock{
            mobile_status
            name
            product_type
            products{
              name
              sku
              special_price
              image {
                url
                label
              }
              price_range {
                maximum_price {
                  discount {
                      amount_off
                      percent_off
                  }
                }
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
              wishlistData{
                wishlistItem
              }       
            }
            store
            store_label
            
          }
          ...on CustomBlock{
          description
          image
          link
          products{
            name
          }
        }
        }
        page_info{
          current_page
          page_size
          total_pages
          __typename
        }
        total_count
        __typename
      }
      }
    }''';

  static String getCountries = '''
    query {
        countries {
            id
            two_letter_abbreviation
            three_letter_abbreviation
            full_name_locale
            full_name_english
            available_regions {
                id
                code
                name
            }
        }
    }''';

  static String getRegion(String code) => '''{
    country(id: "$code") {
        id
        two_letter_abbreviation
        three_letter_abbreviation
        full_name_locale
        full_name_english
        available_regions {
            id
            code
            name
        }
      }
    }''';
}
