class Wishlist {
  String? sTypename;
  int? itemsCount;
  String? sharingCode;
  String? updatedAt;
  List<Items>? items;

  Wishlist({this.sTypename, this.itemsCount, this.sharingCode, this.updatedAt, this.items});

  Wishlist.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    itemsCount = json['items_count'];
    sharingCode = json['sharing_code'];
    updatedAt = json['updated_at'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['items_count'] = itemsCount;
    data['sharing_code'] = sharingCode;
    data['updated_at'] = updatedAt;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? sTypename;
  int? id;
  int? qty;
  String? description;
  String? addedAt;
  Product? product;

  Items({this.sTypename, this.id, this.qty, this.description, this.addedAt, this.product});

  Items.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    id = json['id'];
    qty = json['qty'];
    description = json['description'];
    addedAt = json['added_at'];
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['id'] = id;
    data['qty'] = qty;
    data['description'] = description;
    data['added_at'] = addedAt;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class Product {
  String? name;
  String? sku;
  String? urlKey;
  String? urlSuffix;
  Image? image;
  String? stockStatus;
  String? sTypename;
  double? specialPrice;
  PriceRange? priceRange;
  List<ConfigurableOptions>? configurableOptions;
  List<Variants>? variants;

  Product(
      {this.name,
      this.sku,
      this.urlKey,
      this.urlSuffix,
      this.image,
      this.stockStatus,
      this.sTypename,
      this.specialPrice,
      this.priceRange,
      this.configurableOptions,
      this.variants});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sku = json['sku'];
    urlKey = json['url_key'];
    urlSuffix = json['url_suffix'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    stockStatus = json['stock_status'];
    sTypename = json['__typename'];
    specialPrice = double.tryParse((json['special_price'] ?? '').toString());
    priceRange = json['price_range'] != null ? PriceRange.fromJson(json['price_range']) : null;
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['sku'] = sku;
    data['url_key'] = urlKey;
    data['url_suffix'] = urlSuffix;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['stock_status'] = stockStatus;
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
    percentOff = double.tryParse((json['percent_off'] ?? '').toString());
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

  ConfigurableOptions({this.sTypename, this.id, this.attributeIdV2, this.label, this.position, this.useDefault, this.attributeCode, this.values, this.productId});

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
  String? uid;
  int? valueIndex;
  String? label;
  SwatchData? swatchData;

  Values({this.sTypename, this.uid, this.valueIndex, this.label, this.swatchData});

  Values.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    uid = json['uid'];
    valueIndex = json['value_index'];
    label = json['label'];
    swatchData = json['swatch_data'] != null ? SwatchData.fromJson(json['swatch_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['uid'] = uid;
    data['value_index'] = valueIndex;
    data['label'] = label;
    if (swatchData != null) {
      data['swatch_data'] = swatchData!.toJson();
    }
    return data;
  }
}

class SwatchData {
  String? sTypename;
  String? value;

  SwatchData({this.sTypename, this.value});

  SwatchData.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['value'] = value;
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
