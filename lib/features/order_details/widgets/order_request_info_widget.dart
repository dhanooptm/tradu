import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_request_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class OrderRequestInfoWidget extends StatelessWidget {
  final Variation? variation;
  final OrderRequests? orderRequest;
  const OrderRequestInfoWidget({super.key, this.variation, this.orderRequest});

  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall,
        left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(color: Theme.of(context).highlightColor,),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child:
            variation != null ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('${getTranslated('variation_type', context)}:', style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.bold)),
                    Text('${variation?.variantType}', style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.bold))
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Qty:', style: textRegular.copyWith(color: Theme.of(context).hintColor)),

                  Text('${variation?.quantity}', style: textRegular.copyWith(color: Theme.of(context).hintColor)),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${getTranslated('variation_price', context)}:', style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),),
                  Text(PriceConverter.convertPrice(context,variation?.variantPrice),
                    style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                  ),
                ],
              ),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${getTranslated('price_range', context)}:', style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                  ),
                  Text(PriceConverter.convertPrice(context,variation?.priceRange), style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                  ),
                ],
              )
            ]) :
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${getTranslated('product_name', context)}:', style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.bold)),
                    Text('${orderRequest?.product?.name}', style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.bold))
                  ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Qty:', style: textRegular.copyWith(color: Theme.of(context).hintColor)),

                  Text('${orderRequest?.quantity}', style: textRegular.copyWith(color: Theme.of(context).hintColor)),
                ],
              ), const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${getTranslated('unit_price', context)}:', style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),),
                  Text(PriceConverter.convertPrice(context, orderRequest?.product?.unitPrice),
                    style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                  ),
                ],),const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${getTranslated('unit', context)}:', style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),),
                  Text( '${orderRequest?.product?.unit}',
                    style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                  ),
                ],
              ),
            ])
        ),
      ]),
    );
  }
}
