class ProductModel {
  String? sTypename;
  List<Aggregations>? aggregations;
  List<Items>? items;
  SortFields? sortFields;
  PageInfo? pageInfo;

  ProductModel({this.sTypename, this.aggregations, this.items, this.sortFields, this.pageInfo});

  ProductModel.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    if (json['aggregations'] != null) {
      aggregations = <Aggregations>[];
      json['aggregations'].forEach((v) {
        aggregations!.add(Aggregations.fromJson(v));
      });
    }
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    sortFields = json['sort_fields'] != null ? SortFields.fromJson(json['sort_fields']) : null;
    pageInfo = json['page_info'] != null ? PageInfo.fromJson(json['page_info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    if (aggregations != null) {
      data['aggregations'] = aggregations!.map((v) => v.toJson()).toList();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (sortFields != null) {
      data['sort_fields'] = sortFields!.toJson();
    }
    if (pageInfo != null) {
      data['page_info'] = pageInfo!.toJson();
    }
    return data;
  }
}

class Aggregations {
  String? sTypename;
  String? attributeCode;
  int? count;
  String? label;
  List<AggregationOptions>? options;

  Aggregations({this.sTypename, this.attributeCode, this.count, this.label, this.options});

  Aggregations.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    attributeCode = json['attribute_code'];
    count = json['count'];
    label = json['label'];
    if (json['options'] != null) {
      options = <AggregationOptions>[];
      json['options'].forEach((v) {
        options!.add(AggregationOptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['attribute_code'] = attributeCode;
    data['count'] = count;
    data['label'] = label;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AggregationOptions {
  String? sTypename;
  String? label;
  String? value;
  int? count;

  AggregationOptions({this.sTypename, this.label, this.value, this.count});

  AggregationOptions.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    label = json['label'];
    value = json['value'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['label'] = label;
    data['value'] = value;
    data['count'] = count;
    return data;
  }
}

class Items {
  String? name;
  String? sku;
  String? urlKey;
  String? urlSuffix;
  Image? image;
  int? ratingSummary;
  int? reviewCount;
  String? stockStatus;
  List<Categories>? categories;
  Description? description;
  Description? shortDescription;
  String? sTypename;
  String? specialPrice;
  PriceRange? priceRange;
  List<ConfigurableOptions>? configurableOptions;
  List<Variants>? variants;
  List<MediaGallery>? mediaGallery;
  List<Items>? relatedProducts;
  String? wishlistItem;

  Items({
    this.name,
    this.sku,
    this.urlKey,
    this.image,
    this.ratingSummary,
    this.reviewCount,
    this.stockStatus,
    this.categories,
    this.description,
    this.shortDescription,
    this.sTypename,
    this.specialPrice,
    this.priceRange,
    this.configurableOptions,
    this.variants,
    this.mediaGallery,
    this.relatedProducts,
    this.urlSuffix,
    this.wishlistItem,
  });

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sku = json['sku'];
    urlKey = json['url_key'];
    urlSuffix = json['url_suffix'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    ratingSummary = json['rating_summary'];
    reviewCount = json['review_count'];
    stockStatus = json['stock_status'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    description = json['description'] != null ? Description.fromJson(json['description']) : null;
    shortDescription = json['short_description'] != null ? Description.fromJson(json['short_description']) : null;
    sTypename = json['__typename'];
    specialPrice = json['special_price']?.toString();
    priceRange = json['price_range'] != null ? PriceRange.fromJson(json['price_range']) : null;
    wishlistItem = json['wishlistData']?['wishlistItem'];

    if (json['configurable_options'] != null) {
      configurableOptions = <ConfigurableOptions>[];
      json['configurable_options'].forEach((v) {
        configurableOptions!.add(ConfigurableOptions.fromJson(v));
      });
    }
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(Variants.fromJson(v));
      });
    }
    if (json['media_gallery'] != null) {
      mediaGallery = <MediaGallery>[];
      json['media_gallery'].forEach((v) {
        mediaGallery!.add(MediaGallery.fromJson(v));
      });
    }
    if (json['related_products'] != null) {
      relatedProducts = <Items>[];
      json['related_products'].forEach((v) {
        relatedProducts!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['sku'] = sku;
    data['url_key'] = urlKey;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['rating_summary'] = ratingSummary;
    data['review_count'] = reviewCount;
    data['stock_status'] = stockStatus;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (description != null) {
      data['description'] = description!.toJson();
    }
    if (shortDescription != null) {
      data['short_description'] = shortDescription!.toJson();
    }
    data['__typename'] = sTypename;
    data['special_price'] = specialPrice;
    if (priceRange != null) {
      data['price_range'] = priceRange!.toJson();
    }
    if (configurableOptions != null) {
      data['configurable_options'] = configurableOptions!.map((v) => v.toJson()).toList();
    }
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    if (mediaGallery != null) {
      data['media_gallery'] = mediaGallery!.map((v) => v.toJson()).toList();
    }
    if (relatedProducts != null) {
      data['related_products'] = relatedProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Image {
  String? sTypename;
  String? url;

  Image({this.sTypename, this.url});

  Image.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['url'] = url;
    return data;
  }
}

class Categories {
  String? sTypename;
  String? name;
  String? uid;
  String? path;
  int? id;

  Categories({this.sTypename, this.name, this.uid, this.path, this.id});

  Categories.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    name = json['name'];
    uid = json['uid'];
    path = json['path'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['name'] = name;
    data['uid'] = uid;
    data['path'] = path;
    data['id'] = id;
    return data;
  }
}

class Description {
  String? sTypename;
  String? html;

  Description({this.sTypename, this.html});

  Description.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    html = json['html'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['html'] = html;
    return data;
  }
}

class PriceRange {
  String? sTypename;
  MinimumPrice? minimumPrice;
  MaximumPrice? maximumPrice;

  PriceRange({this.sTypename, this.minimumPrice, this.maximumPrice});

  PriceRange.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    minimumPrice = json['minimum_price'] != null ? MinimumPrice.fromJson(json['minimum_price']) : null;
    maximumPrice = json['maximum_price'] != null ? MaximumPrice.fromJson(json['maximum_price']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    if (minimumPrice != null) {
      data['minimum_price'] = minimumPrice!.toJson();
    }
    if (maximumPrice != null) {
      data['maximum_price'] = maximumPrice!.toJson();
    }
    return data;
  }
}

class MinimumPrice {
  String? sTypename;
  RegularPrice? regularPrice;

  MinimumPrice({this.sTypename, this.regularPrice});

  MinimumPrice.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    regularPrice = json['regular_price'] != null ? RegularPrice.fromJson(json['regular_price']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    if (regularPrice != null) {
      data['regular_price'] = regularPrice!.toJson();
    }
    return data;
  }
}

class RegularPrice {
  String? sTypename;
  double? value;
  String? currency;

  RegularPrice({this.sTypename, this.value, this.currency});

  RegularPrice.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    value = double.parse(json['value'].toString());
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['value'] = value;
    data['currency'] = currency;
    return data;
  }
}

class MaximumPrice {
  String? sTypename;
  RegularPrice? regularPrice;
  Discount? discount;

  MaximumPrice({this.sTypename, this.regularPrice, this.discount});

  MaximumPrice.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    regularPrice = json['regular_price'] != null ? RegularPrice.fromJson(json['regular_price']) : null;
    discount = json['discount'] != null ? Discount.fromJson(json['discount']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    if (regularPrice != null) {
      data['regular_price'] = regularPrice!.toJson();
    }
    if (discount != null) {
      data['discount'] = discount!.toJson();
    }
    return data;
  }
}

class Discount {
  String? sTypename;
  double? amountOff;
  double? percentOff;

  Discount({this.sTypename, this.amountOff, this.percentOff});

  Discount.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    amountOff = double.parse(json['amount_off'].toString());
    percentOff = double.parse(json['percent_off'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['amount_off'] = amountOff;
    data['percent_off'] = percentOff;
    return data;
  }
}

class ConfigurableOptions {
  String? sTypename;
  int? id;
  int? attributeIdV2;
  String? label;
  int? position;
  bool? useDefault;
  String? attributeCode;
  List<Values>? values;
  int? productId;

  ConfigurableOptions({
    this.sTypename,
    this.id,
    this.attributeIdV2,
    this.label,
    this.position,
    this.useDefault,
    this.attributeCode,
    this.values,
    this.productId,
  });

  ConfigurableOptions.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    id = json['id'];
    attributeIdV2 = json['attribute_id_v2'];
    label = json['label'];
    position = json['position'];
    useDefault = json['use_default'];
    attributeCode = json['attribute_code'];
    if (json['values'] != null) {
      values = <Values>[];
      json['values'].forEach((v) {
        values!.add(Values.fromJson(v));
      });
    }
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['id'] = id;
    data['attribute_id_v2'] = attributeIdV2;
    data['label'] = label;
    data['position'] = position;
    data['use_default'] = useDefault;
    data['attribute_code'] = attributeCode;
    if (values != null) {
      data['values'] = values!.map((v) => v.toJson()).toList();
    }
    data['product_id'] = productId;
    return data;
  }
}

class Values {
  String? sTypename;
  int? valueIndex;
  String? label;
  String? swatchData;
  String? uid;

  Values({this.sTypename, this.valueIndex, this.label, this.swatchData, this.uid});

  Values.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    valueIndex = json['value_index'];
    label = json['label'];
    swatchData = json['swatch_data']?['value'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['value_index'] = valueIndex;
    data['label'] = label;
    data['uid'] = uid;
    return data;
  }
}

class Variants {
  String? sTypename;
  Product? product;
  List<Attributes>? attributes;

  Variants({this.sTypename, this.product, this.attributes});

  Variants.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json['attributes'].forEach((v) {
        attributes!.add(Attributes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (attributes != null) {
      data['attributes'] = attributes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  String? sTypename;
  int? id;
  String? name;
  String? sku;
  int? attributeSetId;
  PriceRange? priceRange;
  List<Map<String, dynamic>>? mediaGallery;

  Product({this.sTypename, this.id, this.name, this.sku, this.attributeSetId, this.priceRange, this.mediaGallery});

  Product.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    id = json['id'];
    name = json['name'];
    sku = json['sku'];
    attributeSetId = json['attribute_set_id'];
    priceRange = json['price_range'] != null ? PriceRange.fromJson(json['price_range']) : null;
    mediaGallery = json['media_gallery'] != null ? List<Map<String, dynamic>>.from(json['media_gallery']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['id'] = id;
    data['name'] = name;
    data['sku'] = sku;
    data['attribute_set_id'] = attributeSetId;
    if (priceRange != null) {
      data['price_range'] = priceRange!.toJson();
    }
    data['media_gallery'] = mediaGallery;
    return data;
  }
}

class Attributes {
  String? sTypename;
  String? uid;
  String? label;
  String? code;
  int? valueIndex;

  Attributes({this.sTypename, this.uid, this.label, this.code, this.valueIndex});

  Attributes.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    uid = json['uid'];
    label = json['label'];
    code = json['code'];
    valueIndex = json['value_index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['uid'] = uid;
    data['label'] = label;
    data['code'] = code;
    data['value_index'] = valueIndex;
    return data;
  }
}

class MediaGallery {
  String? sTypename;
  String? url;
  String? label;

  MediaGallery({this.sTypename, this.url, this.label});

  MediaGallery.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    url = json['url'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['url'] = url;
    data['label'] = label;
    return data;
  }
}

class SortFields {
  String? sTypename;
  String? defaultSort;
  List<SortOptions>? options;

  SortFields({this.sTypename, this.defaultSort, this.options});

  SortFields.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    defaultSort = json['default'];
    if (json['options'] != null) {
      options = <SortOptions>[];
      json['options'].forEach((v) {
        options!.add(SortOptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['default'] = defaultSort;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SortOptions {
  String? sTypename;
  String? label;
  String? value;

  SortOptions({this.sTypename, this.label, this.value});

  SortOptions.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}

class PageInfo {
  String? sTypename;
  int? currentPage;
  int? pageSize;
  int? totalPages;

  PageInfo({this.sTypename, this.currentPage, this.pageSize, this.totalPages});

  PageInfo.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    currentPage = json['current_page'];
    pageSize = json['page_size'];
    totalPages = json['total_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['current_page'] = currentPage;
    data['page_size'] = pageSize;
    data['total_pages'] = totalPages;
    return data;
  }
}
