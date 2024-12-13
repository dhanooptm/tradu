import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';


class RequestPriceWidget extends StatefulWidget {
  final ProductDetailsModel? product;

  const RequestPriceWidget({super.key,required this.product});

  @override
  State<RequestPriceWidget> createState() => _RequestPriceWidgetState();
}

class _RequestPriceWidgetState extends State<RequestPriceWidget> {

  final TextEditingController priceInfoController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  final FocusNode priceInfoNode = FocusNode();
  final FocusNode nameNode = FocusNode();
  final FocusNode mobileNode = FocusNode();
  final FocusNode emailNode = FocusNode();
  final FocusNode companyNode = FocusNode();
  final FocusNode pinNode = FocusNode();

  @override
  void dispose() {
    priceInfoController.dispose();
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    companyController.dispose();
    pinController.dispose();
    priceInfoNode.dispose();
    nameNode.dispose();
    mobileNode.dispose();
    emailNode.dispose();
    companyNode.dispose();
    pinNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).cardColor.withOpacity(0.5),
              ),
              padding: const EdgeInsets.all(3),
              child: const Icon(Icons.clear),
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Consumer<ProductDetailsController>(
          builder: (context,productDetailsController,_) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).cardColor,
              ),
              width: size.width,
              height: size.height * 0.8,
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Column(
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Text(getTranslated('receive_price_info', context)!, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          CustomTextFieldWidget(
                            inputType: TextInputType.text,
                            focusNode: priceInfoNode,
                            nextFocus: nameNode,
                            inputAction: TextInputAction.done,
                            controller: priceInfoController,
                            maxLines: 5,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            titleText: getTranslated('name', context),
                            hintText: 'Jhon Doe',
                            inputType: TextInputType.text,
                            focusNode: nameNode,
                            nextFocus: mobileNode,
                            inputAction: TextInputAction.done,
                            controller: nameController,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            titleText: getTranslated('mobile', context),
                            hintText: '+8801XXXXXXXX',
                            inputType: TextInputType.number,
                            focusNode: mobileNode,
                            nextFocus: emailNode,
                            inputAction: TextInputAction.done,
                            controller: mobileController,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            titleText: getTranslated('email', context),
                            hintText: 'email@gmail.com',
                            inputType: TextInputType.emailAddress,
                            focusNode: emailNode,
                            nextFocus: companyNode,
                            inputAction: TextInputAction.done,
                            controller: emailController,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            titleText: getTranslated('company_name', context),
                            inputType: TextInputType.text,
                            focusNode: companyNode,
                            nextFocus: pinNode,
                            inputAction: TextInputAction.done,
                            controller: companyController,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            titleText: getTranslated('pin', context),
                            hintText: '123...',
                            inputType: TextInputType.number,
                            focusNode: pinNode,
                            inputAction: TextInputAction.done,
                            controller: pinController,
                          ), const SizedBox(height: Dimensions.paddingSizeDefault),

                          Row(children: [
                            Checkbox(
                              value: productDetailsController.isDealer,
                              onChanged: (value) => productDetailsController.toggleDealer(value),
                            ),
                            Text(getTranslated('i_am_a_dealer', context)!, style: robotoBold.copyWith( fontSize: Dimensions.fontSizeDefault)),
                          ]),

                          Row(children: [
                            Checkbox(
                              value: productDetailsController.receiveOffers,
                              onChanged: (value) => productDetailsController.toggleOffers(value),
                            ),
                            Text(getTranslated('receive_offers', context)!, style: robotoBold.copyWith( fontSize: Dimensions.fontSizeDefault)),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                        ]),
                      ),
                    ),

                    productDetailsController.loading ? const Center(child: CircularProgressIndicator(),) : CustomButton(buttonText: 'submit',
                      onTap: (){
                        String priceInfo = priceInfoController.text.trim();
                        String name = nameController.text.trim();
                        String mobile = mobileController.text.trim();
                        String company = companyController.text.trim();
                        String email = emailController.text.trim();
                        String pin = pinController.text.trim();

                        if(priceInfo.isEmpty){
                        showCustomSnackBar(getTranslated('enter_request_information', context)!,context);
                        }else if(name.isEmpty){
                          showCustomSnackBar(getTranslated('name_is_required', context)!,context);
                        }else if(mobile.isEmpty){
                          showCustomSnackBar(getTranslated('enter_mobile_number', context)!,context);
                        }else if(email.isEmpty){
                          showCustomSnackBar(getTranslated('enter_your_email', context)!,context);
                        }else if(company.isEmpty){
                          showCustomSnackBar(getTranslated('enter_company_information', context)!,context);
                        }else if(pin.isEmpty){
                          showCustomSnackBar(getTranslated('enter_pin', context)!,context);
                        }else{
                          Navigator.pop(context);
                          productDetailsController.requestPrice(widget.product?.id.toString(), priceInfo, name, email, mobile, company, pin,
                              isDealer: productDetailsController.isDealer, receiveOffers: productDetailsController.receiveOffers
                          );
                        }

                        // orderController.assignThirdParty(widget.orderId, company, tracking, serial);
                      },
                    ),

                  ]),
            );
          }
        ),

      ]),
    );
  }
}