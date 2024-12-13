import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/screens/supply_order_request_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/cart_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/request_price_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/screens/cart_screen.dart';
import 'package:provider/provider.dart';

import 'contact_supplier_widget.dart';

class BottomCartWidget extends StatefulWidget {
  final ProductDetailsModel? product;
  const BottomCartWidget({super.key, required this.product});

  @override
  State<BottomCartWidget> createState() => _BottomCartWidgetState();
}

class _BottomCartWidgetState extends State<BottomCartWidget> {
  bool vacationIsOn = false;
  bool temporaryClose = false;
  bool isGuestMode = !Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn();

  @override
  void initState() {

    super.initState();

    final today = DateTime.now();

    Provider.of<ProductDetailsController>(context, listen: false).toggleOffers(false,notify: false);
    Provider.of<ProductDetailsController>(context, listen: false).toggleDealer(false,notify: false);
    if(widget.product?.addedBy == 'admin'){
      DateTime vacationDate = Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.vacationEndDate != null ?
      DateTime.parse(Provider.of<SplashController>(context, listen: false).configModel!.inhouseVacationAdd!.vacationEndDate!) : DateTime.now();

      DateTime vacationStartDate = Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.vacationStartDate != null ?
      DateTime.parse(Provider.of<SplashController>(context, listen: false).configModel!.inhouseVacationAdd!.vacationStartDate!)  : DateTime.now();

      final difference = vacationDate.difference(today).inDays;
      final startDate = vacationStartDate.difference(today).inDays;

      if(difference >= 0 && (Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.status == 1) && startDate <= 0){
        vacationIsOn = true;
      } else{
        vacationIsOn = false;
      }

    } else if(widget.product != null && widget.product!.seller != null && widget.product!.seller!.shop!.vacationEndDate != null){
      DateTime vacationDate = DateTime.parse(widget.product!.seller!.shop!.vacationEndDate!);
      DateTime vacationStartDate = DateTime.parse(widget.product!.seller!.shop!.vacationStartDate!);
      final difference = vacationDate.difference(today).inDays;
      final startDate = vacationStartDate.difference(today).inDays;

      if(difference >= 0 && widget.product!.seller!.shop!.vacationStatus! && startDate <= 0){
        vacationIsOn = true;
      }

      else{
        vacationIsOn = false;
      }
    }


    if(widget.product?.addedBy == 'admin'){
      if(widget.product != null && (Provider.of<SplashController>(context, listen: false).configModel?.inhouseTemporaryClose?.status == 1)){
        temporaryClose = true;
      }else{
        temporaryClose = false;
      }
    } else {
      if(widget.product != null && widget.product!.seller != null && widget.product!.seller!.shop!.temporaryClose!){
        temporaryClose = true;
      }else{
        temporaryClose = false;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(height: 60,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(color: Theme.of(context).highlightColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        boxShadow: [BoxShadow(color: Theme.of(context).hintColor, blurRadius: .5, spreadRadius: .1)]),
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          child: Stack(children: [
            GestureDetector(onTap: ()  =>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const CartScreen())),
                child: Image.asset(Images.cartArrowDownImage, color: ColorResources.getPrimary(context))),
            Positioned.fill(
              child: Container(
                transform: Matrix4.translationValues(10, -3, 0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Consumer<CartController>(builder: (context, cart, child) {
                    return Container(height: ResponsiveHelper.isTab(context)? 25 : 17, width: ResponsiveHelper.isTab(context)? 25 :17,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: ColorResources.getPrimary(context)),
                      child: Center(
                        child: Text(cart.cartList.length.toString(),
                          style: textRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,
                              color:Theme.of(context).highlightColor)),
                      ),
                    );}),
                ),
              ))])),
        const SizedBox(width: 50),

        widget.product?.priceType == 'priceless' || widget.product?.priceType == 'multiple_price' ?
        Expanded(child: InkWell(onTap: () {
          if(vacationIsOn || temporaryClose ){
            showCustomSnackBar(getTranslated('this_shop_is_close_now', context), context, isToaster: true);
          }else{
            if(isGuestMode){
              Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(body: NotLoggedInWidget(message: getTranslated('need_to_login', context)))));
            }else{
              if(widget.product?.priceType == 'priceless'){
              showDialog(
                context: context, builder: (BuildContext context) {
                return  Dialog(backgroundColor: Colors.transparent, child: ContactSupplierWidget(product: widget.product,));
              },
              );
            }else{
              Navigator.push(context, MaterialPageRoute(builder: (_) => SupplyOrderRequestScreen(product: widget.product,)));}
            }}
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xffFE961C)),
            child: Text(getTranslated(widget.product?.priceType == 'priceless' ? 'contact_supplier' : 'start_order_request', context)!,
              style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault ,
                  color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                  Theme.of(context).hintColor : Theme.of(context).highlightColor),),
          ),
        )) : const SizedBox(),


        Expanded(child: InkWell(onTap: () {
            if(vacationIsOn || temporaryClose ){
              showCustomSnackBar(getTranslated('this_shop_is_close_now', context), context, isToaster: true);
            }else{
              if(widget.product?.priceType == 'single_price'){
                showModalBottomSheet(context: context, isScrollControlled: true,
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0),
                    builder: (con) => CartBottomSheetWidget(product: widget.product, callback: (){
                      showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                    },));
              }else{
                if(isGuestMode){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(body: NotLoggedInWidget(message: getTranslated('need_to_login', context)))));
                }else{
                  if(widget.product?.priceType == 'priceless'){
                    showDialog(
                      context: context, builder: (BuildContext context) {
                      return  Dialog(backgroundColor: Colors.transparent, child: RequestPriceWidget(product: widget.product,));
                    },
                    );
                  }else if(widget.product?.priceType == 'multiple_price'){
                    showDialog(
                      context: context, builder: (BuildContext context) {
                      return  Dialog(backgroundColor: Colors.transparent, child: ContactSupplierWidget(product: widget.product,));
                    },
                    );
                  }
                }
              }
            }},
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor),
            child: Text(getTranslated(widget.product?.priceType == 'priceless' ? 'request_price' :
            widget.product?.priceType == 'multiple_price' ? 'contact_supplier' : 'add_to_cart', context)!,
              style: titilliumSemiBold.copyWith(fontSize: widget.product?.priceType == 'priceless' || widget.product?.priceType == 'multiple_price' ?
              Dimensions.fontSizeDefault : Dimensions.fontSizeLarge,
                  color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                  Theme.of(context).hintColor : Theme.of(context).highlightColor),),
          ),
        )),
      ]),
    );
  }
}
