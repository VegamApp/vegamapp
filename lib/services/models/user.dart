class User {
  Orders? orders;
  List<Addresses>? addresses;
  Map<String, dynamic>? compareList;
  List<Wishlists>? wishlists;

  bool? allowRemoteShoppingAssistance;
  String? createdAt;
  String? dateOfBirth;
  String? defaultBilling;
  String? defaultShipping;
  String? email;
  String? firstname;
  int? gender;
  bool? isSubscribed;
  String? lastname;
  String? middlename;
  String? prefix;
  String? suffix;
  String? taxvat;
  String? mobilenumber;
  // Reviews? reviews;
  String? sTypename;

  User(
      {this.orders,
      this.addresses,
      this.compareList,
      this.wishlists,
      this.allowRemoteShoppingAssistance,
      this.createdAt,
      this.dateOfBirth,
      this.defaultBilling,
      this.defaultShipping,
      this.email,
      this.firstname,
      this.gender,
      this.isSubscribed,
      this.lastname,
      this.middlename,
      this.prefix,
      this.suffix,
      this.taxvat,
      this.mobilenumber,
      // this.reviews,
      this.sTypename});

  User.fromJson(Map<String, dynamic> json) {
    orders = json['orders'] != null ? new Orders.fromJson(json['orders']) : null;
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(new Addresses.fromJson(v));
      });
    }
    compareList = json['compare_list'];
    if (json['wishlists'] != null) {
      wishlists = <Wishlists>[];
      json['wishlists'].forEach((v) {
        wishlists!.add(new Wishlists.fromJson(v));
      });
    }
    allowRemoteShoppingAssistance = json['allow_remote_shopping_assistance'];
    createdAt = json['created_at'];
    dateOfBirth = json['date_of_birth'];
    defaultBilling = json['default_billing'];
    defaultShipping = json['default_shipping'];
    email = json['email'];
    firstname = json['firstname'];
    gender = json['gender'];
    isSubscribed = json['is_subscribed'];
    lastname = json['lastname'];
    middlename = json['middlename'];
    prefix = json['prefix'];
    suffix = json['suffix'];
    taxvat = json['taxvat'];
    mobilenumber = json['mobilenumber'];
    // reviews = json['reviews'] != null ? new Reviews.fromJson(json['reviews']) : null;
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders!.toJson();
    }
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    data['compare_list'] = this.compareList;
    if (this.wishlists != null) {
      data['wishlists'] = this.wishlists!.map((v) => v.toJson()).toList();
    }
    data['allow_remote_shopping_assistance'] = this.allowRemoteShoppingAssistance;
    data['created_at'] = this.createdAt;
    data['date_of_birth'] = this.dateOfBirth;
    data['default_billing'] = this.defaultBilling;
    data['default_shipping'] = this.defaultShipping;
    data['email'] = this.email;
    data['firstname'] = this.firstname;
    data['gender'] = this.gender;
    data['is_subscribed'] = this.isSubscribed;
    data['lastname'] = this.lastname;
    data['middlename'] = this.middlename;
    data['prefix'] = this.prefix;
    data['suffix'] = this.suffix;
    data['taxvat'] = this.taxvat;
    data['mobilenumber'] = this.mobilenumber;
    // if (this.reviews != null) {
    //   data['reviews'] = this.reviews!.toJson();
    // }
    data['__typename'] = this.sTypename;
    return data;
  }
}

class Orders {
  List<OrderItems>? items;
  int? totalCount;
  PageInfo? pageInfo;
  String? sTypename;

  Orders({this.items, this.totalCount, this.pageInfo, this.sTypename});

  Orders.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <OrderItems>[];
      json['items'].forEach((v) {
        items!.add(new OrderItems.fromJson(v));
      });
    }
    totalCount = json['total_count'];
    pageInfo = json['page_info'] != null ? new PageInfo.fromJson(json['page_info']) : null;
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['total_count'] = this.totalCount;
    if (this.pageInfo != null) {
      data['page_info'] = this.pageInfo!.toJson();
    }
    data['__typename'] = this.sTypename;
    return data;
  }
}

class OrderItems {
  String? number;
  Total? total;
  OrderAddress? shippingAddress;
  OrderAddress? billingAddress;
  String? orderDate;
  String? orderNumber;
  List<Items>? items;
  String? shippingMethod;
  String? status;
  List<PaymentMethods>? paymentMethods;
  String? sTypename;

  OrderItems(
      {this.number,
      this.total,
      this.shippingAddress,
      this.billingAddress,
      this.orderDate,
      this.orderNumber,
      this.items,
      this.shippingMethod,
      this.status,
      this.paymentMethods,
      this.sTypename});

  OrderItems.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    total = json['total'] != null ? new Total.fromJson(json['total']) : null;
    shippingAddress = json['shipping_address'] != null ? new OrderAddress.fromJson(json['shipping_address']) : null;
    billingAddress = json['billing_address'] != null ? new OrderAddress.fromJson(json['billing_address']) : null;
    orderDate = json['order_date'];
    orderNumber = json['order_number'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    shippingMethod = json['shipping_method'];
    status = json['status'];
    if (json['payment_methods'] != null) {
      paymentMethods = <PaymentMethods>[];
      json['payment_methods'].forEach((v) {
        paymentMethods!.add(new PaymentMethods.fromJson(v));
      });
    }
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    if (this.total != null) {
      data['total'] = this.total!.toJson();
    }
    if (this.shippingAddress != null) {
      data['shipping_address'] = this.shippingAddress!.toJson();
    }
    if (this.billingAddress != null) {
      data['billing_address'] = this.billingAddress!.toJson();
    }
    data['order_date'] = this.orderDate;
    data['order_number'] = this.orderNumber;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['shipping_method'] = this.shippingMethod;
    data['status'] = this.status;
    if (this.paymentMethods != null) {
      data['payment_methods'] = this.paymentMethods!.map((v) => v.toJson()).toList();
    }
    data['__typename'] = this.sTypename;
    return data;
  }
}

class Total {
  GrandTotal? grandTotal;
  String? sTypename;

  Total({this.grandTotal, this.sTypename});

  Total.fromJson(Map<String, dynamic> json) {
    grandTotal = json['grand_total'] != null ? new GrandTotal.fromJson(json['grand_total']) : null;
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.grandTotal != null) {
      data['grand_total'] = this.grandTotal!.toJson();
    }
    data['__typename'] = this.sTypename;
    return data;
  }
}

class GrandTotal {
  double? value;
  String? sTypename;

  GrandTotal({this.value, this.sTypename});

  GrandTotal.fromJson(Map<String, dynamic> json) {
    value = double.parse(json['value'].toString());
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['__typename'] = this.sTypename;
    return data;
  }
}

class Items {
  GrandTotal? productSalePrice;
  String? id;
  String? productUrlKey;
  String? productSku;
  int? quantityOrdered;
  String? productName;
  String? productImage;
  String? sTypename;

  Items({this.productSalePrice, this.id, this.productUrlKey, this.productSku, this.quantityOrdered, this.productName, this.productImage, this.sTypename});

  Items.fromJson(Map<String, dynamic> json) {
    productSalePrice = json['product_sale_price'] != null ? new GrandTotal.fromJson(json['product_sale_price']) : null;
    id = json['id'];
    productUrlKey = json['product_url_key'];
    productSku = json['product_sku'];
    quantityOrdered = json['quantity_ordered'];
    productName = json['product_name'];
    productImage = json['product_image'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productSalePrice != null) {
      data['product_sale_price'] = this.productSalePrice!.toJson();
    }
    data['id'] = this.id;
    data['product_url_key'] = this.productUrlKey;
    data['product_sku'] = this.productSku;
    data['quantity_ordered'] = this.quantityOrdered;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['__typename'] = this.sTypename;
    return data;
  }
}

class PaymentMethods {
  String? name;
  String? sTypename;

  PaymentMethods({this.name, this.sTypename});

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['__typename'] = this.sTypename;
    return data;
  }
}

class OrderAddress {
  String? firstname;
  String? lastname;
  String? city;
  List<String>? street;
  String? region;
  String? countryCode;
  String? sTypename;

  OrderAddress({this.firstname, this.lastname, this.city, this.region, this.countryCode, this.sTypename, this.street});

  OrderAddress.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
    city = json['city'];
    region = json['region'];
    street = json['street'].cast<String>();
    countryCode = json['country_code'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['city'] = this.city;
    data['region'] = this.region;
    data['country_code'] = this.countryCode;
    data['__typename'] = this.sTypename;
    return data;
  }
}

class PageInfo {
  int? pageSize;
  int? totalPages;
  int? currentPage;
  String? sTypename;

  PageInfo({this.pageSize, this.totalPages, this.currentPage, this.sTypename});

  PageInfo.fromJson(Map<String, dynamic> json) {
    pageSize = json['page_size'];
    totalPages = json['total_pages'];
    currentPage = json['current_page'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_size'] = this.pageSize;
    data['total_pages'] = this.totalPages;
    data['current_page'] = this.currentPage;
    data['__typename'] = this.sTypename;
    return data;
  }
}

class Addresses {
  String? city;
  String? company;
  String? countryCode;
  bool? defaultBilling;
  bool? defaultShipping;
  String? extensionAttributes;
  String? fax;
  String? firstname;
  int? id;
  String? lastname;
  String? middlename;
  String? postcode;
  String? prefix;
  Region? region;
  List<String>? street;
  String? suffix;
  String? telephone;
  String? sTypename;

  Addresses(
      {this.city,
      this.company,
      this.countryCode,
      this.defaultBilling,
      this.defaultShipping,
      this.extensionAttributes,
      this.fax,
      this.firstname,
      this.id,
      this.lastname,
      this.middlename,
      this.postcode,
      this.prefix,
      this.region,
      this.street,
      this.suffix,
      this.telephone,
      this.sTypename});

  Addresses.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    company = json['company'];
    countryCode = json['country_code'];
    defaultBilling = json['default_billing'];
    defaultShipping = json['default_shipping'];
    extensionAttributes = json['extension_attributes'];
    fax = json['fax'];
    firstname = json['firstname'];
    id = json['id'];
    lastname = json['lastname'];
    middlename = json['middlename'];
    postcode = json['postcode'];
    prefix = json['prefix'];
    region = json['region'] != null ? new Region.fromJson(json['region']) : null;
    street = json['street'].cast<String>();
    suffix = json['suffix'];
    telephone = json['telephone'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['company'] = this.company;
    data['country_code'] = this.countryCode;
    data['default_billing'] = this.defaultBilling;
    data['default_shipping'] = this.defaultShipping;
    data['extension_attributes'] = this.extensionAttributes;
    data['fax'] = this.fax;
    data['firstname'] = this.firstname;
    data['id'] = this.id;
    data['lastname'] = this.lastname;
    data['middlename'] = this.middlename;
    data['postcode'] = this.postcode;
    data['prefix'] = this.prefix;
    if (this.region != null) {
      data['region'] = this.region!.toJson();
    }
    data['street'] = this.street;
    data['suffix'] = this.suffix;
    data['telephone'] = this.telephone;
    data['__typename'] = this.sTypename;
    return data;
  }
}

class Region {
  String? region;
  String? regionCode;
  int? regionId;
  String? sTypename;

  Region({this.region, this.regionCode, this.regionId, this.sTypename});

  Region.fromJson(Map<String, dynamic> json) {
    region = json['region'];
    regionCode = json['region_code'];
    regionId = json['region_id'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['region'] = this.region;
    data['region_code'] = this.regionCode;
    data['region_id'] = this.regionId;
    data['__typename'] = this.sTypename;
    return data;
  }
}

class Wishlists {
  String? id;
  int? itemsCount;
  String? sTypename;

  Wishlists({this.id, this.itemsCount, this.sTypename});

  Wishlists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemsCount = json['items_count'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['items_count'] = this.itemsCount;
    data['__typename'] = this.sTypename;
    return data;
  }
}

// class Reviews {
//   String? sTypename;
//   List<Null>? items;

//   Reviews({this.sTypename, this.items});

//   Reviews.fromJson(Map<String, dynamic> json) {
//     sTypename = json['__typename'];
//     if (json['items'] != null) {
//       items = <Null>[];
//       json['items'].forEach((v) {
//         items!.add(new Null.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['__typename'] = this.sTypename;
//     if (this.items != null) {
//       data['items'] = this.items!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
