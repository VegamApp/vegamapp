class SearchModel {
  String? name;
  String? imgUrl;
  String? sku;

  SearchModel({this.imgUrl, this.name, this.sku});

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
        name: json['name'],
        imgUrl: json['image']['url'],
        sku: json['sku'],
      );
}
