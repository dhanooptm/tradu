import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/order_request_body.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';


class CompleteOrderRequestWidget extends StatelessWidget {
  final double priceWithQuantity;
  final ProductDetailsModel? product;
  final ProductDetailsController productDetailsController;
  final OrderRequestBody orderRequestBody;
  const CompleteOrderRequestWidget({super.key,required this.priceWithQuantity,required this.product,required this.productDetailsController,required this.orderRequestBody});

  @override
  Widget build(BuildContext context) {
    return Container(height: 100,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(color: Theme.of(context).highlightColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          boxShadow: [BoxShadow(color: Theme.of(context).hintColor, blurRadius: .5, spreadRadius: .1)]),
      child: productDetailsController.range != null && productDetailsController.range == false ? Container(
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
        alignment: Alignment.center,
        child: Text(getTranslated( 'no_range_price_available', context)!,
          style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge,
              color: Provider.of<ThemeController>(context, listen: false).darkTheme?
              Theme.of(context).hintColor : Theme.of(context).colorScheme.error),),
      ) :

      productDetailsController.loading ? const Center(child: CircularProgressIndicator(),) : Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(getTranslated('total_price', context)!, style: robotoBold),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Row(children: [
            CustomDirectionalityWidget(
              child: Text(PriceConverter.convertPrice(context, priceWithQuantity),
                  style: titilliumBold.copyWith(color: ColorResources.getPrimary(context), fontSize: Dimensions.fontSizeLarge)),
            ), const SizedBox(width: Dimensions.paddingSizeSmall),

            productDetailsController.productDetailsModel?.taxModel == 'exclude' ?
            Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
              child: Row(
                children: [
                  Text('(', style: titilliumRegular.copyWith(
                    color: ColorResources.hintTextColor,
                    fontSize: Dimensions.fontSizeDefault,
                  )),

                  Text('${getTranslated('tax', context)} : ', style: titilliumRegular.copyWith(
                    color: ColorResources.hintTextColor,
                    fontSize: Dimensions.fontSizeDefault,
                  )),

                  CustomDirectionalityWidget(
                    child: Text('${productDetailsController.productDetailsModel?.tax}%', style: titilliumRegular.copyWith(
                      color: ColorResources.hintTextColor,
                      fontSize: Dimensions.fontSizeDefault,
                    )),
                  ),

                  Text(')', style: titilliumRegular.copyWith(
                    color: ColorResources.hintTextColor,
                    fontSize: Dimensions.fontSizeDefault,
                  )),
                ],
              ),

            ):
            Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                child: Text('(${getTranslated('tax', context)} ${productDetailsController.productDetailsModel?.tax})',
                    style: titilliumRegular.copyWith(color: ColorResources.hintTextColor, fontSize: Dimensions.fontSizeDefault)))
          ],
          ),
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Expanded(
          child: InkWell(onTap: () {
            if(productDetailsController.quantity! > product!.currentStock! && product?.productType != "digital"){
              showCustomSnackBar('${getTranslated('stock_limit_exceeded', context)}${product!.currentStock!}', context, isToaster: true);
            }else{
              productDetailsController.orderRequest(orderRequestBody);
            }
          },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor),
              child: Text(getTranslated( 'complete_order_request', context)!,
                style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge,
                    color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                    Theme.of(context).hintColor : Theme.of(context).highlightColor),),
            ),
          ),
        ),
      ]),
    );
  }
}
