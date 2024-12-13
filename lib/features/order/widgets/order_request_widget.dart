import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_request_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/screens/order_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/screens/order_request_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';


class OrderRequestWidget extends StatelessWidget {
  final OrderRequests? orderRequests;
  const OrderRequestWidget({super.key, this.orderRequests});

  @override
  Widget build(BuildContext context) {

    int? quantity = 0;
    if(orderRequests!.variation != null && orderRequests!.variation!.isNotEmpty){
      Variation variation;
      for(variation in orderRequests!.variation!){
        quantity = quantity! + variation.quantity!;
      }
    }else{
      quantity = orderRequests?.quantity;
    }

    return Stack(
      children: [
        InkWell(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderRequestDetailScreen(orderRequest: orderRequests,)));},

          child: Container(margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall,
              left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(color: Theme.of(context).highlightColor,
              borderRadius: BorderRadius.circular(5),
              boxShadow:  [BoxShadow(color: Colors.grey.withOpacity(.2), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 1))],),

            child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 82,height: 82,
                  child: Column(children: [
                    Container(decoration: BoxDecoration(color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                      border: Border.all(width: 1, color: Theme.of(context).primaryColor.withOpacity(.25)),
                      boxShadow: Provider.of<ThemeController>(context, listen: false).darkTheme? null :[BoxShadow(color: Colors.grey.withOpacity(.2), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 1))],),

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                        child: CustomImageWidget(
                          placeholder: Images.placeholder, fit: BoxFit.scaleDown, width: 70, height: 70,
                          image: '${orderRequests?.product?.thumbnailFullUrl?.path}',
                          )),),]),),
                const SizedBox(width: Dimensions.paddingSizeLarge),



                Expanded(flex: 5,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text('${getTranslated('order', context)!}# ${orderRequests!.id.toString()}',
                          style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.bold)))]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Text(DateConverter.localDateToIsoStringAMPMOrder(DateTime.parse(orderRequests!.createdAt!)),
                        style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Text(PriceConverter.convertPrice(context,orderRequests!.orderAmount),
                      style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: ColorResources.getPrimary(context)),
                    )
                    ])),



                Container(alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,vertical: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: orderRequests!.orderStatus == 'unread'? ColorResources.getYellow(context).withOpacity(.1) :
                      ColorResources.getGreen(context).withOpacity(.10), borderRadius: BorderRadius.circular(50)),

                    child: Text(getTranslated('${orderRequests!.orderStatus}', context)??'',
                        style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w500,
                      color: orderRequests!.orderStatus == 'unread'? ColorResources.getYellow(context) : ColorResources.getGreen(context)))),

              ]),
            ),
          ),
        ),

        Positioned(top: 2, left: Provider.of<LocalizationController>(context, listen: false).isLtr? 90 : MediaQuery.of(context).size.width-50, child: Container(
          height: 22,
          width: 22,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
          child: FittedBox(child: Text(
            "$quantity",
            style: textRegular.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          )),
        )),
      ],
    );
  }
}
