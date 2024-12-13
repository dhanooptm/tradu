import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/price_range_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class PriceRangeTextWidget extends StatelessWidget {
  final ProductDetailsModel? productDetailsModel;
  const PriceRangeTextWidget({super.key, required this.productDetailsModel});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 80, child:
      ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: productDetailsModel?.priceRangeList?.length ?? 0,
        itemBuilder: (context, index) {
          PriceRangeModel priceRange = productDetailsModel!.priceRangeList![index];
          String startPoint = priceRange.startPoint ?? '';
          String endPoint = priceRange.endPoint ?? '';
          String price = priceRange.price ?? '';

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeEight), // Add some spacing between items
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(getTranslated('quantity', context)!, style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                Text('$startPoint -${endPoint.isNotEmpty ? endPoint : " ∞"}',
                  style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,), //
                Row(
                  children: [
                    productDetailsModel?.discount != null && (productDetailsModel?.discount ?? 0) > 0 ?
                      CustomDirectionalityWidget(
                        child: Text('\$$price',
                            style: titilliumRegular.copyWith(color: Theme.of(context).hintColor,
                                decoration: TextDecoration.lineThrough)),
                      ) : const SizedBox(),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall,),

                    Text(PriceConverter.convertWithDiscount(context, double.tryParse(priceRange.price!), productDetailsModel!.discount, productDetailsModel?.discountType).toString(), style: titilliumRegular.copyWith(color: ColorResources.getPrimary(context),
                        fontSize: Dimensions.fontSizeExtraLarge), textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                  ],
                ),
              ],
            ),
          );
        },
      ),

      ),
    ],) ;
  }
}