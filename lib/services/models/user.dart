class User {
  String? firstname;
  String? lastname;
  String? suffix;
  String? email;
  int? gender;
  bool? isSubscribed;
  List<Addresses>? addresses = [];

  User({this.firstname, this.lastname, this.suffix, this.email, this.gender, this.isSubscribed, this.addresses});

  User.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
    suffix = json['suffix'];
    email = json['email'];
    gender = json['gender'];
    isSubscribed = json['is_subscribed'];

    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['suffix'] = suffix;
    data['email'] = email;
    data['gender'] = gender;
    data['is_subscribed'] = isSubscribed;

    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addresses {
  String? firstname;
  String? lastname;
  List<String>? street;
  String? city;
  Region? region;
  String? postcode;
  String? countryCode;
  String? telephone;

  Addresses({this.firstname, this.lastname, this.street, this.city, this.region, this.postcode, this.countryCode, this.telephone});

  Addresses.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
    street = json['street'].cast<String>();
    city = json['city'];
    region = json['region'] != null ? Region.fromJson(json['region']) : null;
    postcode = json['postcode'];
    countryCode = json['country_code'];
    telephone = json['telephone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['street'] = street;
    data['city'] = city;
    if (region != null) {
      data['region'] = region!.toJson();
    }
    data['postcode'] = postcode;
    data['country_code'] = countryCode;
    data['telephone'] = telephone;
    return data;
  }
}

class Region {
  String? regionCode;
  String? region;

  Region({this.regionCode, this.region});

  Region.fromJson(Map<String, dynamic> json) {
    regionCode = json['region_code'];
    region = json['region'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['region_code'] = regionCode;
    data['region'] = region;
    return data;
  }
}
