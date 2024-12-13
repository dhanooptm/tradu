
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/order_request_body.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/repositories/product_details_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsRepository implements ProductDetailsRepositoryInterface {
  final DioClient? dioClient;
  final SharedPreferences sharedPreferences;
  ProductDetailsRepository({required this.dioClient, required this.sharedPreferences});

  @override
  Future<ApiResponse> get(String productID) async {
    try {
      final response = await dioClient!.get('${AppConstants.productDetailsUri}$productID?guest_id=1');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }




  @override
  Future<ApiResponse> getCount(String productID) async {
    try {
      final response = await dioClient!.get(AppConstants.counterUri+productID);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getSharableLink(String productID) async {
    try {
      final response = await dioClient!.get(AppConstants.socialLinkUri+productID);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> requestPrice(String? productID, String? description, String? name, String? email, String phone, String? company, String? pin,{bool? isDealer, bool? receiveOffers}) async {

    try {
      final response = await dioClient!.post('${AppConstants.requestPriceUri}?product_id=$productID&&descriptions=$description&name=$name&email=$email&phone=$phone&company=$company&pin=$pin',
          data: {
            'is_dealer' : '$isDealer',
            'similar_info' : '$receiveOffers'
          },);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> contactSupplier(String? productID,String quantity, String? description, String? name, String? email, String phone) async {

    try {
      final response = await dioClient!.post('${AppConstants.contactSupplierUri}?product_id=$productID&quantity=$quantity&descriptions=$description&name=$name&email=$email&phone=$phone',);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> orderRequest(OrderRequestBody orderRequestBody) async {
    try {
      final response = await dioClient!.post(AppConstants.orderRequestUri,
          data: {'product_id' : orderRequestBody.productId,
            'variation' : orderRequestBody.variation,
            'quantity' : orderRequestBody.quantity,
            'user_id' : sharedPreferences.getString(AppConstants.userId)
          });

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }


}