class SearchModel {
  String? name;
  String? imgUrl;
  String? sku;
  String? urlKey;
  String? urlSuffix;
  SearchModel({this.imgUrl, this.name, this.sku, this.urlKey, this.urlSuffix});

  factory SearchModel.fromJson(Map<String, dynamic> json) =>
      SearchModel(name: json['name'], imgUrl: json['image']['url'], sku: json['sku'], urlKey: json['url_key'], urlSuffix: json['url_suffix']);
}
