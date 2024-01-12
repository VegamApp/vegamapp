import 'dart:math';

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

  Future<List<SearchModel>> searchSuggessionApi(
      {required searchQuery, required BuildContext context}) async {
    var graphqlClient = GraphQLProvider.of(context);
    QueryResult? result = await graphqlClient.value.query(WatchQueryOptions(
        document: searchSuggession, variables: {"searchQuery": searchQuery}));
    List<SearchModel> searchModelList = [];
    if (result.data != null) {
      try {
        searchModelList = List<SearchModel>.generate(
          result.data!['products']['items'].length,
          (index) =>
              SearchModel.fromJson(result.data!['products']['items'][index]),
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
    blocks {
      data{
        id
        desktop_status
        desktop_status
        title
        mobile_status
        title
        show_title
        store
        store_label
        __typename
        ... on SliderBlock{
          templateType
          slider_width
          autoplay
          show_slider_title
          autoplay_timeout
          autoplay_hover_pause
          show_dots
          banners {
            image
            layout
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
          sliders {
            position
            description
            start_date
            end_date
            slider_image
            link_info{
              link_type
              category_id
              link_url
              external_url
              product_id
              product_sku
            }
          } 
        }
        ...on BannerBlock{
          banner_template
          banneritems {
            image
            layout
            title
            position
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
        }
        ...on ContentBlock{
          content
          
        }
        ...on ProductBlock{
          show_title
          product_type
          products {
            __typename
            type_id
            name
            url_suffix
            url_key
            sku
            id
            stock_status
            rating_summary
            review_count
            categories {
              image
              name
              __typename
            }
            image {
              url
              label
              __typename
            }
            small_image {
              url
              label
              __typename
            }
            special_price
            price_range{
              minimum_price{
                regular_price{
                  value
                  currency
                }
                discount {
                  amount_off
                  percent_off
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
          __typename
        }
        ... on CategoryBlock{
          title
          category_info{
            category_id
            url_key
            image
            name
          }
          id
          mobile_status
          desktop_status
          show_title
          store
          store_label
          
        }
        ...on CustomBlock{
          description
          viewall_status
          image
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
          products{
            name
          }
        }
        ...on PopUp{
            popup_type
            popup_image
            click_url{
              link_type
              link_url
              external_url
              category_id
              page_id
              product_id
              product_sku
              page_id
            }
            video_thumbnail
            video_link
            block_identifier
            start_date
            end_date
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
  }
''';

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

  Future<bool> sendNewsLetter(String email) async {
    Random random = Random();
    await Future.delayed(Duration(seconds: 3));
    return (random.nextInt(3) % 2 == 0);
  }
}
