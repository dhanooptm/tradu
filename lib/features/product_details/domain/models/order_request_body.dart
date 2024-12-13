import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';

class OrderRequestBody{
  int? productId;
  List<Variation>? variation;
  int? quantity = 0;


  OrderRequestBody(
      {this.productId,
        this.variation,
        this.quantity,
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['variation'] = variation;
    data['quantity'] = quantity;
    return data;
  }
}