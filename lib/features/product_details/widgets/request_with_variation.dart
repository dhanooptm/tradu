
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/order_request_body.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/cart_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/color_selection_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/complete_order_request_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/price_range_text_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:provider/provider.dart';


class RequestWithVariationWidget extends StatefulWidget {
  final ProductDetailsModel? product;
  const RequestWithVariationWidget({super.key, required this.product});

  @override
  RequestWithVariationWidgetState createState() => RequestWithVariationWidgetState();
}

class RequestWithVariationWidgetState extends State<RequestWithVariationWidget> {
  List<TextEditingController?> quantityController = [];
  List<FocusNode?> quantityNode = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    for (int i=0; i < widget.product!.variation!.length; i++ ) {
      Provider.of<ProductDetailsController>(context, listen: false).variationList?.add(widget.product!.variation![i]);
      Provider.of<ProductDetailsController>(context, listen: false).setVariationQuantity(i,0,notify: false);
      quantityController.add(TextEditingController());
      quantityNode.add(FocusNode());
      quantityController[i] = TextEditingController(text: Provider.of<ProductDetailsController>(context, listen: false).variationList?[i].toString());
    }

    super.initState();
  }

  @override
  void dispose() {
    for(int i = 0; i< widget.product!.variation!.length; i++){
      quantityController[i]?.dispose();
      quantityNode[i]?.dispose();
    }
    scrollController.dispose();
    quantityController.clear();
    quantityNode.clear();
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



          //Variation? variation;
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

          double?  price = PriceConverter.calMultiPriceVariation(context, details.productDetailsModel?.priceRangeList, details.variationList);
          int? stock = widget.product!.currentStock;
          variationType = variationType.replaceAll(' ', '');
          for(Variation variation in widget.product!.variation!) {
            if(variation.type == variationType) {
              variation = variation;
              stock = variation.qty;
              break;
            }
          }

          if(variationFileType.isNotEmpty && extentions.isNotEmpty) {
            variantKey = '${variationFileType[details.digitalVariationIndex!]}-${extentions[details.digitalVariationIndex!][details.digitalVariationSubindex!]}';
          }
          digitalVariantPrice = variantKey != null ? price : null;

          int? totalQuantity = 0;

          if(details.variationList != null && details.variationList!.isNotEmpty){
            for(int i=0;i<details.variationList!.length;i++){
              totalQuantity = totalQuantity! + details.variationList![i].quantity!;
            }
          }

          double totalPrice = PriceConverter.convertWithDiscountVariation(context,
              price, widget.product!.discount, widget.product!.discountType,totalQuantity)!;


          OrderRequestBody orderRequestBody = OrderRequestBody(
            productId: widget.product!.id,
            variation: details.variationList
          );

          return Column(mainAxisSize: MainAxisSize.min, children: [
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

                        (widget.product!.colors != null && widget.product!.colors!.isNotEmpty) ?
                        ColorSelectionWidget(product: widget.product!, detailsController: details) : const SizedBox(),


                        (widget.product!.colors != null && widget.product!.colors!.isNotEmpty) ?
                        const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),


                        /// Variation
                        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.product!.choiceOptions!.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                Text('${getTranslated('available', context)}  ${widget.product!.choiceOptions![index].title} : ',
                                    style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),


                                Expanded(child: Padding(padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: SizedBox(height: 40,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: widget.product!.choiceOptions![index].options!.length,
                                      itemBuilder: (ctx, i) {
                                        return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                          child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                              color: Theme.of(context).colorScheme.onTertiary),
                                            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                                border: Border.all(width: 2,color: const Color(0x00FFFFFF))),
                                              child: Padding(padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault),
                                                child: Center(child: Text(widget.product!.choiceOptions![index].options![i].trim(), maxLines: 1,
                                                    overflow: TextOverflow.ellipsis, style: titilliumRegular.copyWith(
                                                        fontSize: Dimensions.fontSizeDefault,
                                                        color: Theme.of(context).primaryColor ))),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                ),
                              ]);
                            },
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall,),


                        /// Digital Product Variation
                        variationFileType.isNotEmpty ?
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: variationFileType.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) {

                              return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                Text('${variationFileType[index][0].toUpperCase() + variationFileType[index].substring(1)} : ',
                                    style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                Expanded(
                                  child: Padding(padding: const EdgeInsets.all(2.0),
                                    child: GridView.builder(
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5,
                                        childAspectRatio: (1 / .5),
                                      ),
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: extentions[index].length,
                                      itemBuilder: (ctx, i) {
                                        bool isSelect = (details.digitalVariationIndex == index && details.digitalVariationSubindex == i);
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: isSelect ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.10),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                            child: Text(extentions[index][i].trim(), maxLines: 1,
                                                overflow: TextOverflow.ellipsis, style: titilliumRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeDefault,
                                                  color: isSelect ?  Colors.white : Theme.of(context).primaryColor.withOpacity(0.85),
                                                )),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ]);
                            },
                          ),
                        ) : const SizedBox(),
                        variationFileType.isNotEmpty ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),


                        Card(child: Container(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                            decoration: BoxDecoration(color: Theme.of(context).highlightColor),
                            child: Column(children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                itemCount: widget.product?.variation?.length,
                                itemBuilder: (context, index) {

                                  quantityController[index] = TextEditingController(text: details.variationList?[index].quantity.toString());

                                  if (quantityNode[index]!.hasFocus) {
                                    scrollController.animateTo(
                                      scrollController.offset + (100),
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }

                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraExtraSmall),
                                    height: 100,
                                    decoration: BoxDecoration(color: Theme.of(context).highlightColor,
                                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.15), width: .75)),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                            margin: const EdgeInsets.only(left: Dimensions.paddingSizeEight),
                                            decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.10),width: 0.5)),
                                            child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                                child: CustomImageWidget(image: '${widget.product!.thumbnailFullUrl?.path}',fit: BoxFit.contain,))),
                                      ),
                                      const SizedBox(width: Dimensions.paddingSizeSmall,),

                                      Expanded(
                                        flex: 4,
                                        child: Column( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text('${widget.product?.variation![index].type}', maxLines: 1,
                                                overflow: TextOverflow.ellipsis, style: titilliumRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeDefault,
                                                  color: Theme.of(context).primaryColorDark,
                                                )),
                                            Text('\$${widget.product?.variation![index].price}', maxLines: 1,
                                                overflow: TextOverflow.ellipsis, style: titilliumRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeDefault,
                                                  color: Theme.of(context).primaryColor,
                                                )),
                                          ],
                                        ),
                                      ),


                                    /// Quantity
                                    Expanded(
                                      flex: 4,
                                      child: Row(children: [
                                        QuantityButton(isIncrement: false, quantity: details.variationList?[index].quantity, stock: stock, minimumOrderQuantity: widget.product!.minimumOrderQty,
                                            digitalProduct: widget.product!.productType == "digital", withVariation: true,index: index),
                                        const SizedBox(width: Dimensions.paddingSizeSmall,),

                                        SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: TextFormField(
                                            controller: quantityController[index],
                                            focusNode: quantityNode[index],
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                                            ),
                                            onFieldSubmitted: (value){
                                              int? quantity = int.tryParse(value);
                                              if(quantity! > stock! && widget.product?.productType != "digital"){
                                                showCustomSnackBar('${getTranslated('stock_limit_exceeded ', context)}', context, isToaster: true);
                                                quantityController[index]?.clear();
                                              }else if (quantity > 1) {
                                                if(quantity > widget.product!.minimumOrderQty!) {
                                                  Provider.of<ProductDetailsController>(context, listen: false).setVariationQuantity(index, quantity);
                                                }else{
                                                  showCustomSnackBar('${getTranslated('minimum_quantity_is', context)}${widget.product!.minimumOrderQty!}', context, isToaster: true);
                                                }
                                              } else if (quantity < stock || widget.product?.productType == "digital") {
                                                Provider.of<ProductDetailsController>(context, listen: false).setVariationQuantity(index, quantity);
                                              }
                                            },
                                          ),
                                        ), const SizedBox(width: Dimensions.paddingSizeSmall,),

                                        QuantityButton(isIncrement: true, quantity: details.variationList?[index].quantity, stock: stock, minimumOrderQuantity: widget.product!.minimumOrderQty,
                                            digitalProduct: widget.product!.productType == "digital", withVariation: true,index: index,)]),
                                    ),
                                  ],),
                                );},
                              ),

                            ],
                            )
                        ),),


                        const SizedBox(height: 50,),

                      ]),
                    ],
                  ),
                ),
              ),
            ),
            CompleteOrderRequestWidget(priceWithQuantity: totalPrice,productDetailsController: details,product: widget.product, orderRequestBody: orderRequestBody,),
          ],);
        }
    );
  }
}
