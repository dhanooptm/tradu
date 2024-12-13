import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/controllers/order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_request_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/cal_chat_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/cancel_and_support_center_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/order_amount_calculation.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/order_details_status_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/ordered_product_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/payment_info_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/seller_section_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/shipping_and_billing_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/shipping_info_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/order_request_info_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/image_diaglog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/screens/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/order_details_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class OrderRequestDetailScreen extends StatelessWidget {
  final OrderRequests? orderRequest;
  const OrderRequestDetailScreen({super.key, required this.orderRequest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 1, backgroundColor: Theme.of(context).cardColor,
          toolbarHeight: 120, leadingWidth: 0, automaticallyImplyLeading: false,
          title:  OrderDetailsStatusWidget(isRequest: true,orderRequest: orderRequest)),

      body: Column(children: [
        const SizedBox(height: Dimensions.paddingSizeDefault,),
        CustomImageWidget(
          placeholder: Images.placeholder, fit: BoxFit.cover,
          image: '${orderRequest?.product?.thumbnailFullUrl?.path}',
        ),

        orderRequest!.variation != null && orderRequest!.variation!.isNotEmpty ?
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              itemCount: orderRequest?.variation?.length,
              itemBuilder: (context, i) => OrderRequestInfoWidget(variation: orderRequest!.variation![i],)
                    ),
          ) : Expanded(child: OrderRequestInfoWidget(orderRequest: orderRequest,)),

          Container(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(color: Theme.of(context).highlightColor,
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(.2), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 1))],),

            child: Column(children: [

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("${getTranslated('discount', context)}: ",
                  style: titilliumRegular.copyWith(color: ColorResources.hintTextColor, fontSize: 14),),

                Text('${orderRequest?.discount}',
                    style: titilliumRegular.copyWith(color: ColorResources.getPrimary(context), fontSize: 16)),
              ]),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("${getTranslated('total', context)}: ",
                  style: titilliumRegular.copyWith(color: ColorResources.hintTextColor, fontSize: 14),),

                Row(children: [
                  Text(PriceConverter.convertPrice(context, orderRequest?.orderAmount),
                    style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context), fontSize: 16),),
                  Text(' (${getTranslated('tax', context)} ${orderRequest?.tax})',
                      style: titilliumRegular.copyWith(color: ColorResources.hintTextColor, fontSize: Dimensions.fontSizeDefault))
                ],
                ),
              ]),
            ],),
          ),
      ],
      )
    );
  }
}
