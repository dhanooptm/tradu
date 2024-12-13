import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/price_range_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:provider/provider.dart';

class PriceConverter {
  static String convertPrice(BuildContext context, double? price, {double? discount, String? discountType}) {
    if(discount != null && discountType != null){
      if(discountType == 'amount' || discountType == 'flat') {
        price = price! - discount;
      }else if(discountType == 'percent' || discountType == 'percentage') {
        price = price! - ((discount / 100) * price);
      }
    }
    bool singleCurrency = Provider.of<SplashController>(context, listen: false).configModel!.currencyModel == 'single_currency';
    bool inRight = Provider.of<SplashController>(context, listen: false).configModel!.currencySymbolPosition == 'right';

    return '${inRight ? '' : Provider.of<SplashController>(context, listen: false).myCurrency!.symbol}'
        '${(singleCurrency? price : price! * Provider.of<SplashController>(context, listen: false).myCurrency!.exchangeRate!
        * (1/Provider.of<SplashController>(context, listen: false).usdCurrency!.exchangeRate!))!.toStringAsFixed(Provider.of<SplashController>(context,listen: false).configModel!.decimalPointSettings??1).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
        '${inRight ? Provider.of<SplashController>(context, listen: false).myCurrency!.symbol : ''}';
  }

  static double? convertWithDiscount(BuildContext context, double? price, double? discount, String? discountType) {
    if(discountType == 'amount' || discountType == 'flat') {
      price = price! - discount!;
    }else if(discountType == 'percent' || discountType == 'percentage') {
      price = price! - ((discount! / 100) * price);
    }
    return price;
  }


  static double? convertWithDiscountVariation(BuildContext context, double? price, double? discount, String? discountType, int? quantity) {
    if(discountType == 'amount' || discountType == 'flat') {
      price = price! - (discount!* quantity!);
    }else if(discountType == 'percent' || discountType == 'percentage') {
      price = price! - (((discount! * quantity!) / 100) * price);
    }
    return price;
  }

  static double? calculateMultiPrice(BuildContext context, List<PriceRangeModel>? priceRangeList, int? quantity) {

    double? price = 0;
    bool rangeExist = false;

    if(quantity == 0){
      return price;
    }

    if (quantity != null && priceRangeList!.isNotEmpty) {
      for (var range in priceRangeList) {
        double startPoint = double.tryParse(range.startPoint!) ?? 0;
        double endPoint = range.endless! ? double.infinity : double.tryParse(range.endPoint!) ?? 0;
        if (quantity >= startPoint && quantity <= endPoint && range.price != null) {
          price = double.tryParse(range.price!);
          Provider.of<ProductDetailsController>(context, listen: false).isRangeAvailable(true);
          rangeExist = true;
          break;
        }else{
          rangeExist = false;
        }
      }
      if(rangeExist == false){
        Provider.of<ProductDetailsController>(context, listen: false).isRangeAvailable(false);
      }
    }

    return price;
  }

  static double? calMultiPriceVariation(BuildContext context, List<PriceRangeModel>? priceRangeList, List<Variation>? variation) {

    double? totalPrice = 0;
    bool rangeExist = false;


    for (int v = 0; v < variation!.length; v++ ) {

      double? price = 0;
      if (variation[v].quantity != null && priceRangeList!.isNotEmpty && variation[v].quantity != 0) {
        for (var range in priceRangeList) {
          double startPoint = double.tryParse(range.startPoint!) ?? 0;
          double endPoint = range.endless! ? double.infinity : double.tryParse(range.endPoint!) ?? 0;
          if (variation[v].quantity! >= startPoint && variation[v].quantity! <= endPoint && range.price != null) {

            price = (double.tryParse(range.price!)! + variation[v].price!) * variation[v].quantity!;
            totalPrice = totalPrice! + price;
            Provider.of<ProductDetailsController>(context, listen: false).isRangeAvailable(true);
            rangeExist = true;
            break;
          }else{
            rangeExist = false;
          }
        }
        if(rangeExist == false){
          Provider.of<ProductDetailsController>(context, listen: false).isRangeAvailable(false);
          break;
        }
      }

    }



    return totalPrice;
  }


  static double calculation(double amount, double discount, String type, int quantity) {
    double calculatedAmount = 0;
    if(type == 'amount' || type == 'flat') {
      calculatedAmount = discount * quantity;
    }else if(type == 'percent' || type == 'percentage') {
      calculatedAmount = (discount / 100) * (amount * quantity);
    }
    return calculatedAmount;
  }

  static String percentageCalculation(BuildContext context, double? price, double? discount, String? discountType) {
    return '-${(discountType == 'percent' || discountType == 'percentage') ? '$discount %'
        : convertPrice(context, discount)}';
  }
}