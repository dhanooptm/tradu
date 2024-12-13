import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/controllers/order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/widgets/order_request_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/widgets/order_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class OrderRequestScreen extends StatefulWidget {
  const OrderRequestScreen({super.key});

  @override
  State<OrderRequestScreen> createState() => _OrderRequestScreenState();
}

class _OrderRequestScreenState extends State<OrderRequestScreen> {
  ScrollController scrollController  = ScrollController();
  bool isGuestMode = !Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn();
  @override
  void initState() {
    super.initState();
    if(!isGuestMode){
      Provider.of<OrderController>(context, listen: false).getOrderRequest(1,isUpdate: false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('order_request', context), isBackButtonExist: true),
      body: isGuestMode ? NotLoggedInWidget(message: getTranslated('to_view_the_order_history', context)) :

      Consumer<OrderController>(
          builder: (context, orderController, child) {
            return Column(children: [

              const SizedBox(height: Dimensions.paddingSizeLarge,),

              Expanded(child: orderController.orderRequestModel != null ? (orderController.orderRequestModel!.orders != null && orderController.orderRequestModel!.orders!.isNotEmpty) ?
              SingleChildScrollView(
                controller: scrollController,
                child: PaginatedListView(scrollController: scrollController,
                  onPaginate: (int? offset) async{
                    await orderController.getOrderRequest(offset!);
                  },
                  totalSize: orderController.orderRequestModel?.totalSize,
                  offset: orderController.orderRequestModel?.offset != null ? orderController.orderRequestModel!.offset! :1,
                  itemView: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orderController.orderRequestModel?.orders!.length,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) => OrderRequestWidget(orderRequests: orderController.orderRequestModel?.orders![index],),
                  ),

                ),
              ) : const OrderShimmerWidget() :
              const NoInternetOrDataScreenWidget(isNoInternet: false, icon: Images.noOrder, message: 'no_order_found',))
            ],);
          }
      ),
    );
  }
}
