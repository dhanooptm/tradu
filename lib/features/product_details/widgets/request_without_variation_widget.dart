import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/order_request_body.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/complete_order_request_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/price_range_text_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

import 'cart_bottom_sheet_widget.dart';

class RequestWithoutVariationWidget extends StatefulWidget {
  final ProductDetailsModel? product;
  const RequestWithoutVariationWidget({super.key, required this.product});

  @override
  State<RequestWithoutVariationWidget> createState() => RequestWithoutVariationWidgetState();
}

class RequestWithoutVariationWidgetState extends State<RequestWithoutVariationWidget> {
  TextEditingController? quantityController;
  ScrollController scrollController = ScrollController();
  FocusNode quantityNode = FocusNode();

  @override
  void dispose() {
    quantityController?.dispose();
    quantityNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsController>(
        builder: (ctx, details, child) {

          List<String> variationFileType = [];
          List<List<String>> extentions = [];
          String? variantKey;
          double? digitalVariantPrice;

          String? colorWiseSelectedImage = '';

          if(widget.product != null && widget.product!.colorImagesFullUrl != null && widget.product!.colorImagesFullUrl!.isNotEmpty){
            for(int i=0; i< widget.product!.colorImagesFullUrl!.length; i++){
              if(widget.product!.colorImagesFullUrl![i].color == '${widget.product!.colors?[details.variantIndex??0].code?.substring(1, 7)}'){
                colorWiseSelectedImage = widget.product!.colorImagesFullUrl![i].imageName?.path;
              }
            }
          }

          String? variantName = (widget.product!.colors != null && widget.product!.colors!.isNotEmpty) ?
          widget.product!.colors![details.variantIndex!].name : null;
          List<String> variationList = [];
          for(int index=0; index < widget.product!.choiceOptions!.length; index++) {
            variationList.add(widget.product!.choiceOptions![index].options![details.variationIndex![index]].trim());

          }
          String variationType = '';
          if(variantName != null) {
            variationType = variantName;
            for (var variation in variationList) {
              variationType = '$variationType-$variation';
            }
          }else {

            bool isFirst = true;
            for (var variation in variationList) {
              if(isFirst) {
                variationType = '$variationType$variation';
                isFirst = false;
              }else {
                variationType = '$variationType-$variation';
              }
            }
          }

          if(widget.product?.digitalProductExtensions != null){
            widget.product?.digitalProductExtensions?.keys.forEach((key) {
              variationFileType.add(key);
              extentions.add(widget.product?.digitalProductExtensions?[key]);
            }
            );
          }

          double? price = PriceConverter.calculateMultiPrice(context, details.productDetailsModel?.priceRangeList, details.quantity);
          int? stock = widget.product!.currentStock;
          variationType = variationType.replaceAll(' ', '');
          for(Variation variation in widget.product!.variation!) {
            if(variation.type == variationType) {
              price = price! + variation.price!;
              variation = variation;
              stock = variation.qty;
              break;
            }
          }

          if(variationFileType.isNotEmpty && extentions.isNotEmpty) {
            variantKey = '${variationFileType[details.digitalVariationIndex!]}-${extentions[details.digitalVariationIndex!][details.digitalVariationSubindex!]}';
            for (int i=0; i<widget.product!.digitalVariation!.length; i++) {
              if(widget.product!.digitalVariation?[i].variantKey == variantKey){
                price = price! + double.tryParse(widget.product!.digitalVariation![i].price.toString())!;
              }
            }
          }
          digitalVariantPrice = variantKey != null ? price : null;

          double priceWithDiscount = PriceConverter.convertWithDiscount(context,
              price, widget.product!.discount, widget.product!.discountType)!;

          double priceWithQuantity = priceWithDiscount * details.quantity!;

          OrderRequestBody orderRequestBody = OrderRequestBody(
              productId: widget.product!.id,
              variation: null,
              quantity: details.quantity,
          );

          quantityController = TextEditingController(text: Provider.of<ProductDetailsController>(context, listen: false).quantity.toString());

          if (quantityNode.hasFocus) {
            scrollController.animateTo(
              scrollController.offset + 300,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }

          return Column( children: [
            Expanded(

              child: SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  padding: const EdgeInsets.only(top : Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(color: Theme.of(context).highlightColor,
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                  child: Column(
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                        /// Product details
                        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
                            child: Column(children: [
                              Column( crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(width: 300, height: 200,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                          border: Border.all(width: .5,color: Theme.of(context).primaryColor.withOpacity(.20))),
                                      child: ClipRRect(borderRadius: BorderRadius.circular(5),
                                          child: CustomImageWidget(image: (widget.product!.colors != null && widget.product!.colors!.isNotEmpty &&
                                              widget.product!.imagesFullUrl != null && widget.product!.imagesFullUrl!.isNotEmpty) ?
                                          '$colorWiseSelectedImage':
                                          '${widget.product!.thumbnailFullUrl?.path}'))),
                                  const SizedBox(height: 10),
                                  widget.product!.productType != "digital" ?
                                  Text('$stock ${getTranslated('in_stock', context)}',
                                      style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                                      maxLines: 1) : const SizedBox(),
                                ],
                              )])),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Expanded(child:
                            Text(widget.product!.name ?? '',
                                  style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                                  maxLines: 2, overflow: TextOverflow.ellipsis),
                            ),
                            const SizedBox(height:  Dimensions.paddingSizeSmall),
                          ]),
                        ),


                        Row( mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            PriceRangeTextWidget(productDetailsModel: widget.product),
                          ],
                        ), const SizedBox(height: Dimensions.paddingSizeDefault),

                        /// Quantity
                        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
                            child: Row(children: [
                              Text(getTranslated('quantity', context)!, style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                              const SizedBox(width: Dimensions.paddingSizeSmall,),
                              QuantityButton(isIncrement: false, quantity: details.quantity,
                                  stock: stock, minimumOrderQuantity: widget.product!.minimumOrderQty,
                                  digitalProduct: widget.product!.productType == "digital"),
                              const SizedBox(width: Dimensions.paddingSizeSmall,),

                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  controller: quantityController,
                                  focusNode: quantityNode,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  onFieldSubmitted: (value){
                                    int? quantity = int.tryParse(value);
                                    if(quantity! > stock! && widget.product?.productType != "digital"){
                                      showCustomSnackBar('${getTranslated('stock_limit_exceeded', context)}', context, isToaster: true);
                                      quantityController?.clear();
                                    }else if (quantity > 1 ) {
                                      if(quantity > widget.product!.minimumOrderQty!) {
                                        Provider.of<ProductDetailsController>(context, listen: false).setQuantity(quantity);
                                      }else{
                                        showCustomSnackBar('${getTranslated('minimum_quantity_is', context)}${widget.product!.minimumOrderQty!}', context, isToaster: true);
                                      }
                                    } else if (quantity < stock || widget.product?.productType == "digital") {
                                      Provider.of<ProductDetailsController>(context, listen: false).setQuantity(quantity);
                                    }
                                  },
                                ),
                              ), const SizedBox(width: Dimensions.paddingSizeSmall,),

                              QuantityButton(isIncrement: true, quantity: details.quantity, stock: stock,
                                  minimumOrderQuantity: widget.product!.minimumOrderQty,
                                  digitalProduct: widget.product!.productType == "digital")])),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            CompleteOrderRequestWidget(priceWithQuantity: priceWithQuantity,productDetailsController: details,product: widget.product, orderRequestBody: orderRequestBody,),
          ],);
        }
    );
  }
}
