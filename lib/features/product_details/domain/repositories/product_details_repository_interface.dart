import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/order_request_body.dart';
import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class ProductDetailsRepositoryInterface implements RepositoryInterface{
  Future<dynamic> getCount(String productID);
  Future<dynamic> getSharableLink(String productID);
  Future<dynamic> requestPrice(String? productID, String? description, String? name, String? email, String phone, String? company, String? pin,{bool? isDealer,bool? receiveOffers});
  Future<dynamic> contactSupplier(String? productID,String quantity, String? description, String? name, String? email, String phone);
  Future<dynamic> orderRequest(OrderRequestBody orderRequestBody);

}