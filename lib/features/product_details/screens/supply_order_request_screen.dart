
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/request_with_variation.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/request_without_variation_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:provider/provider.dart';


class SupplyOrderRequestScreen extends StatefulWidget {
  final ProductDetailsModel? product;
  const SupplyOrderRequestScreen({super.key, required this.product});

  @override
  SupplyOrderRequestScreenState createState() => SupplyOrderRequestScreenState();
}

class SupplyOrderRequestScreenState extends State<SupplyOrderRequestScreen> {


  @override
  void initState() {
    Provider.of<ProductDetailsController>(context, listen: false).initData(widget.product!,widget.product!.minimumOrderQty, context);
    Provider.of<ProductDetailsController>(context, listen: false).initDigitalVariationIndex();
    Provider.of<ProductDetailsController>(context, listen: false).variationList?.clear();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('order_request', context)),
      body:  widget.product!.variation!.isNotEmpty ? RequestWithVariationWidget(product: widget.product) : RequestWithoutVariationWidget(product: widget.product,)
    );
  }
}
