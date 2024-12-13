import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/velidate_check.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';


class ContactSupplierWidget extends StatefulWidget {
  final ProductDetailsModel? product;

  const ContactSupplierWidget({super.key,required this.product});

  @override
  State<ContactSupplierWidget> createState() => _ContactSupplierWidgetState();
}

class _ContactSupplierWidgetState extends State<ContactSupplierWidget> {

  final TextEditingController quantityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();


  final FocusNode quantityNode = FocusNode();
  final FocusNode descriptionNode = FocusNode();
  final FocusNode nameNode = FocusNode();
  final FocusNode mobileNode = FocusNode();
  final FocusNode emailNode = FocusNode();




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
                height: size.height * 0.7,
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Column(
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                            const SizedBox(height: Dimensions.paddingSizeLarge),

                            Text('${widget.product?.name}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            CustomTextFieldWidget(
                              titleText: getTranslated('quantity', context),
                              inputType: TextInputType.number,
                              focusNode: quantityNode,
                              nextFocus: descriptionNode,
                              inputAction: TextInputAction.done,
                              controller: quantityController,
                              hintText: '123...',
                              validator: (value)=> ValidateCheck.validateNumber(value),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),

                            CustomTextFieldWidget(
                              titleText: getTranslated('description', context),
                              hintText: getTranslated('describe_your_sourcing_requirements_for_products', context),
                              inputType: TextInputType.text,
                              focusNode: descriptionNode,
                              nextFocus: nameNode,
                              inputAction: TextInputAction.done,
                              controller: descriptionController,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),

                            CustomTextFieldWidget(
                              titleText: getTranslated('name', context),
                              hintText: 'Jhon Doe',
                              inputType: TextInputType.text,
                              focusNode: nameNode,
                              nextFocus: emailNode,
                              inputAction: TextInputAction.done,
                              controller: nameController,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),

                            CustomTextFieldWidget(
                              titleText: getTranslated('email', context),
                              hintText: 'email@gmail.com',
                              inputType: TextInputType.emailAddress,
                              focusNode: emailNode,
                              nextFocus: mobileNode,
                              inputAction: TextInputAction.done,
                              controller: emailController,
                                validator: (value) => ValidateCheck.validateEmail(value),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),

                            CustomTextFieldWidget(
                              titleText: getTranslated('mobile', context),
                              hintText: '+8801XXXXXXXX',
                              inputType: TextInputType.number,
                              focusNode: mobileNode,
                              inputAction: TextInputAction.done,
                              controller: mobileController,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),
                          ]),
                        ),
                      ),

                      productDetailsController.loading ? const Center(child: CircularProgressIndicator(),) : CustomButton(buttonText: 'submit',
                        onTap: (){
                          String quantity = quantityController.text.trim();
                          String description = descriptionController.text.trim();
                          String name = nameController.text.trim();
                          String mobile = mobileController.text.trim();
                          String email = emailController.text.trim();

                          if(quantity.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(quantity)){
                            showCustomSnackBar(getTranslated('enter_quantity', context)!,context);
                          }else if(description.isEmpty){
                            showCustomSnackBar(getTranslated('enter_request_information', context)!,context);
                          }else if(name.isEmpty){
                            showCustomSnackBar(getTranslated('name_is_required', context)!,context);
                          }else if(email.isEmpty){
                            showCustomSnackBar(getTranslated('enter_your_email', context)!,context);
                          }else if(mobile.isEmpty){
                            showCustomSnackBar(getTranslated('enter_mobile_number', context)!,context);
                          }else{
                            Navigator.pop(context);
                            productDetailsController.contactSupplier(widget.product?.id.toString(),quantity, description, name, email, mobile);
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

  @override
  void dispose() {
    quantityController.dispose();
    descriptionController.dispose();
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    quantityNode.dispose();
    descriptionNode.dispose();
    nameNode.dispose();
    mobileNode.dispose();
    emailNode.dispose();
    super.dispose();
  }
}