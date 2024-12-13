import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/order_request_body.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/repositories/product_details_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/services/product_details_service_interface.dart';

class ProductDetailsService implements ProductDetailsServiceInterface{
  ProductDetailsRepositoryInterface productDetailsRepositoryInterface;

  ProductDetailsService({required this.productDetailsRepositoryInterface});

  @override
  Future get(String productID) async{
    return await productDetailsRepositoryInterface.get(productID);
  }

  @override
  Future getCount(String productID) async{
    return await productDetailsRepositoryInterface.getCount(productID);
  }

  @override
  Future getSharableLink(String productID) async{
    return await productDetailsRepositoryInterface.getSharableLink(productID);
  }

  @override
  Future requestPrice(String? productID, String? description, String? name, String? email, String phone, String? company, String? pin,{bool? isDealer,bool? receiveOffers}) async {
    return await productDetailsRepositoryInterface.requestPrice(productID,description,name,email,phone,company,pin,isDealer: isDealer, receiveOffers: receiveOffers);
  }

  @override
  Future contactSupplier(String? productID,String quantity, String? description, String? name, String? email, String phone) async {
    return await productDetailsRepositoryInterface.contactSupplier(productID,quantity, description, name, email, phone);
  }

  @override
  Future orderRequest(OrderRequestBody orderRequestBody) async {
    return await productDetailsRepositoryInterface.orderRequest(orderRequestBody);
  }

}