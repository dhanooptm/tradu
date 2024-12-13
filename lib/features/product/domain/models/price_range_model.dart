class PriceRangeModel {
  String? startPoint;
  String? endPoint;
  String? price;
  bool? endless;

  PriceRangeModel({this.startPoint, this.endPoint, this.price, this.endless});

  PriceRangeModel.fromJson(Map<String, dynamic> json) {
    startPoint = json['start_point'];
    endPoint = json['end_point'];
    price = json['price'];
    endless = json['endless'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_point'] = startPoint;
    data['end_point'] = endPoint;
    data['price'] = price;
    data['endless'] = endless;
    return data;
  }
}
