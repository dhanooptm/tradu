import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/order_request_body.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/services/product_details_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:provider/provider.dart';

class ProductDetailsController extends ChangeNotifier {
  final ProductDetailsServiceInterface productDetailsServiceInterface;
  ProductDetailsController({required this.productDetailsServiceInterface});


  int? _imageSliderIndex;
  int? _quantity = 0;
  int? _variantIndex;
  List<int>? _variationIndex;
  int? _orderCount;
  int? _wishCount;
  String? _sharableLink;
  int? _digitalVariationIndex = 0;
  int? _digitalVariationSubindex = 0;
  bool? _isDealer;
  bool? _receiveOffers;
  bool? _range;
  List<Variation>? _variationList;
  bool _loading = false;

  bool _isDetails = false;
  bool get isDetails =>_isDetails;
  int? get imageSliderIndex => _imageSliderIndex;
  int? get quantity => _quantity;
  int? get variantIndex => _variantIndex;
  List<int>? get variationIndex => _variationIndex;
  int? get orderCount => _orderCount;
  int? get wishCount => _wishCount;
  String? get sharableLink => _sharableLink;
  ProductDetailsModel? _productDetailsModel;
  ProductDetailsModel? get productDetailsModel => _productDetailsModel;
  int? get digitalVariationIndex => _digitalVariationIndex;
  int? get digitalVariationSubindex => _digitalVariationSubindex;
  bool? get isDealer => _isDealer;
  bool? get receiveOffers => _receiveOffers;
  bool? get range => _range;
  List<Variation>? get variationList => _variationList;
  bool get loading => _loading;



  Future<void> getProductDetails(BuildContext context, String productId, String slug) async {
    _isDetails = true;
    log("=====slug===>$slug/ $productId");
    ApiResponse apiResponse = await productDetailsServiceInterface.get(slug);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isDetails = false;
      _productDetailsModel = ProductDetailsModel.fromJson(apiResponse.response!.data);
      if(_productDetailsModel != null){
        log("=====slug===>$slug/ $productId");
        Provider.of<SellerProductController>(Get.context!, listen: false).
        getSellerProductList(_productDetailsModel?.addedBy == 'admin' ? '0' : productDetailsModel!.userId.toString(), 1, productId, reload: true);
      }
    } else {
      _isDetails = false;
      showCustomSnackBar(apiResponse.error.toString(), Get.context!);
    }
    _isDetails = false;
    notifyListeners();
  }




  void initData(ProductDetailsModel product, int? minimumOrderQuantity, BuildContext context) {
    _variantIndex = 0;
    _quantity = minimumOrderQuantity;
    _variationIndex = [];
    _variationList = [];
    _range = false;
    for (int i=0; i<= product.choiceOptions!.length; i++) {
      _variationIndex!.add(0);
    }
  }

  bool isReviewSelected = false;
  void selectReviewSection(bool review, {bool isUpdate = true}){
    isReviewSelected = review;

    if(isUpdate) {
      notifyListeners();

    }
  }



  void getCount(String productID, BuildContext context) async {
    ApiResponse apiResponse = await productDetailsServiceInterface.getCount(productID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _orderCount = apiResponse.response!.data['order_count'];
      _wishCount = apiResponse.response!.data['wishlist_count'];
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }


  void getSharableLink(String productID, BuildContext context) async {
    ApiResponse apiResponse = await productDetailsServiceInterface.getSharableLink(productID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _sharableLink = apiResponse.response!.data;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }

  void requestPrice(String? productID, String? description, String? name, String? email, String phone, String? company, String? pin,{bool? isDealer,bool? receiveOffers}) async {
    _loading = true;
    notifyListeners();
    ApiResponse apiResponse = await productDetailsServiceInterface.requestPrice(productID, description, name, email, phone, company, pin, isDealer: isDealer, receiveOffers: receiveOffers);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
       String message = apiResponse.response!.data['message'];
       showCustomSnackBar(message, Get.context!, isToaster: true,isError: false);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    toggleDealer(false,notify: false);
    toggleOffers(false,notify: false);
    _loading = false;
    notifyListeners();
  }

  void contactSupplier(String? productID,String quantity, String? description, String? name, String? email, String phone) async {
    _loading = true;
    notifyListeners();
    ApiResponse apiResponse = await productDetailsServiceInterface.contactSupplier(productID, quantity, description, name, email, phone);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      String message = apiResponse.response!.data['message'];
      showCustomSnackBar(message, Get.context!, isToaster: true,isError: false);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _loading = false;
    notifyListeners();
  }


  void orderRequest(OrderRequestBody orderRequestBody) async {
    _loading = true;
    notifyListeners();
    ApiResponse apiResponse = await productDetailsServiceInterface.orderRequest(orderRequestBody);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      String message = apiResponse.response!.data['message'];
      showCustomSnackBar(message, Get.context!, isToaster: true,isError: false);
    } else {
      //Navigator.pushReplacement(Get.context!, MaterialPageRoute(builder: (_)=> const HomePage()));
      ApiChecker.checkApi(apiResponse);
    }
    _loading = false;
    Navigator.pop(Get.context!);
    notifyListeners();
  }


  void setImageSliderSelectedIndex(int selectedIndex) {
    _imageSliderIndex = selectedIndex;
    notifyListeners();
  }


  void setQuantity(int value) {
    _quantity = value;
    notifyListeners();
  }


  void setVariationQuantity(int index, int value,{notify = true}) {
    _variationList?[index].quantity = value;
    if(notify){
      notifyListeners();
    }
  }

  void setCartVariantIndex(int? minimumOrderQuantity,int index, BuildContext context) {
    _variantIndex = index;
    _quantity = minimumOrderQuantity;
    notifyListeners();
  }


  void setCartVariationIndex(int? minimumOrderQuantity, int index, int i, BuildContext context) {
    _variationIndex![index] = i;
    _quantity = minimumOrderQuantity;
    notifyListeners();
  }


  void removePrevLink() {
    _sharableLink = null;
  }

  bool isValidYouTubeUrl(String url) {
    RegExp regex = RegExp(
      r'^https?:\/\/(?:www\.)?(youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
    );

    return regex.hasMatch(url);
  }

  void setDigitalVariationIndex(int? minimumOrderQuantity, int index, int subIndex, BuildContext context) {
    _quantity = minimumOrderQuantity;
    _digitalVariationIndex = index;
    _digitalVariationSubindex = subIndex;
    notifyListeners();
  }

  void initDigitalVariationIndex() {
    _digitalVariationIndex = 0;
    _digitalVariationSubindex = 0;
  }

  void toggleDealer(bool? value,{bool notify = true}){
   _isDealer = value ?? false;
   if(notify){
     notifyListeners();
   }
  }

  void toggleOffers(bool? value,{bool notify = true}){
    _receiveOffers = value ?? false;
   if(notify){
     notifyListeners();
   }
  }

  void isRangeAvailable(bool? value){
    _range = value;
  }

  void disposeAllControllers(int index, List<TextEditingController> controllers){
    controllers[index].dispose();
  }



}
