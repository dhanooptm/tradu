import 'dart:convert';

import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';

class OrderRequestModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<OrderRequests>? orders;

  OrderRequestModel({this.totalSize, this.limit, this.offset, this.orders});

  OrderRequestModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = int.tryParse(json['limit']);
    offset = int.tryParse(json['offset']);
    if (json['orders'] != null) {
      orders = <OrderRequests>[];
      json['orders'].forEach((v) {
        orders!.add(OrderRequests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderRequests {
  int? id;
  int? customerId;
  int? sellerId;
  int? productId;
  String? paymentStatus;
  String? orderStatus;
  double? orderAmount;
  List<Variation>? variation;
  int? quantity;
  double? discount;
  double? tax;
  String? createdAt;
  String? updatedAt;
  int? priceRange;
  Product? product;

  OrderRequests(
      {this.id,
        this.customerId,
        this.sellerId,
        this.productId,
        this.paymentStatus,
        this.orderStatus,
        this.orderAmount,
        this.variation,
        this.quantity,
        this.discount,
        this.tax,
        this.createdAt,
        this.updatedAt,
        this.priceRange,
        this.product,});

  OrderRequests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    sellerId = json['seller_id'];
    productId = json['product_id'];
    paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    orderAmount = json['order_amount'].toDouble();
    if (json['variation'] != null) {
      variation = <Variation>[];
      jsonDecode(json['variation']).forEach((v) {
        variation!.add(Variation.fromJson(v));
      });
    }
    quantity = json['quantity'];
    discount = json['discount'].toDouble();
    tax = json['tax'].toDouble();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    priceRange = json['price_range'];
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['seller_id'] = sellerId;
    data['product_id'] = productId;
    data['payment_status'] = paymentStatus;
    data['order_status'] = orderStatus;
    data['order_amount'] = orderAmount;
    data['variation'] = variation;
    data['quantity'] = quantity;
    data['discount'] = discount;
    data['tax'] = tax;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['price_range'] = priceRange;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  String? addedBy;
  int? userId;
  String? name;
  String? slug;
  String? productType;
  String? categoryIds;
  int? categoryId;
  int? subCategoryId;
  Null subSubCategoryId;
  int? brandId;
  String? unit;
  int? minQty;
  int? refundable;
  Null digitalProductType;
  String? digitalFileReady;
  String? images;
  String? colorImage;
  String? thumbnail;
  String? thumbnailStorageType;
  String? videoProvider;
  String? colors;
  int? variantProduct;
  String? attributes;
  String? choiceOptions;
  String? variation;
  int? published;
  double? unitPrice;
  int? purchasePrice;
  int? tax;
  String? taxType;
  String? taxModel;
  int? discount;
  String? discountType;
  int? currentStock;
  int? minimumOrderQty;
  String? details;
  int? freeShipping;
  String? createdAt;
  String? updatedAt;
  int? status;
  int? featuredStatus;
  String? metaTitle;
  String? metaDescription;
  int? requestStatus;
  int? shippingCost;
  int? multiplyQty;
  String? code;
  String? priceType;
  String? productMultiPrice;
  int? isShopTemporaryClose;
  List<ImageFullUrl>? imagesFullUrl;
  ImageFullUrl? thumbnailFullUrl;

  Product(
      {this.id,
        this.addedBy,
        this.userId,
        this.name,
        this.slug,
        this.productType,
        this.categoryIds,
        this.categoryId,
        this.subCategoryId,
        this.subSubCategoryId,
        this.brandId,
        this.unit,
        this.minQty,
        this.refundable,
        this.digitalProductType,
        this.digitalFileReady,
        this.images,
        this.colorImage,
        this.thumbnail,
        this.thumbnailStorageType,
        this.videoProvider,
        this.colors,
        this.variantProduct,
        this.attributes,
        this.choiceOptions,
        this.variation,
        this.published,
        this.unitPrice,
        this.purchasePrice,
        this.tax,
        this.taxType,
        this.taxModel,
        this.discount,
        this.discountType,
        this.currentStock,
        this.minimumOrderQty,
        this.details,
        this.freeShipping,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.featuredStatus,
        this.metaTitle,
        this.metaDescription,
        this.requestStatus,
        this.shippingCost,
        this.multiplyQty,
        this.code,
        this.priceType,
        this.productMultiPrice,
        this.isShopTemporaryClose,
        this.imagesFullUrl,
      this.thumbnailFullUrl});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addedBy = json['added_by'];
    userId = json['user_id'];
    name = json['name'];
    slug = json['slug'];
    productType = json['product_type'];
    categoryIds = json['category_ids'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    subSubCategoryId = json['sub_sub_category_id'];
    brandId = json['brand_id'];
    unit = json['unit'];
    minQty = json['min_qty'];
    refundable = json['refundable'];
    digitalProductType = json['digital_product_type'];
    digitalFileReady = json['digital_file_ready'];
    images = json['images'];
    colorImage = json['color_image'];
    thumbnail = json['thumbnail'];
    thumbnailStorageType = json['thumbnail_storage_type'];
    videoProvider = json['video_provider'];
    colors = json['colors'];
    variantProduct = json['variant_product'];
    attributes = json['attributes'];
    choiceOptions = json['choice_options'];
    variation = json['variation'];
    published = json['published'];
    unitPrice = double.tryParse(json['unit_price'].toString());
    purchasePrice = json['purchase_price'];
    tax = json['tax'];
    taxType = json['tax_type'];
    taxModel = json['tax_model'];
    discount = json['discount'];
    discountType = json['discount_type'];
    currentStock = json['current_stock'];
    minimumOrderQty = json['minimum_order_qty'];
    details = json['details'];
    freeShipping = json['free_shipping'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    featuredStatus = json['featured_status'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    requestStatus = json['request_status'];
    shippingCost = json['shipping_cost'];
    multiplyQty = json['multiply_qty'];
    code = json['code'];
    priceType = json['price_type'];
    productMultiPrice = json['product_multi_price'];
    isShopTemporaryClose = json['is_shop_temporary_close'];
    if (json['images_full_url'] != null) {
      imagesFullUrl = <ImageFullUrl>[];
      json['images_full_url'].forEach((v) {
        imagesFullUrl!.add(ImageFullUrl.fromJson(v));
      });
    }
    thumbnailFullUrl = json['thumbnail_full_url'] != null ? ImageFullUrl.fromJson(json['thumbnail_full_url']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['added_by'] = addedBy;
    data['user_id'] = userId;
    data['name'] = name;
    data['slug'] = slug;
    data['product_type'] = productType;
    data['category_ids'] = categoryIds;
    data['category_id'] = categoryId;
    data['sub_category_id'] = subCategoryId;
    data['sub_sub_category_id'] = subSubCategoryId;
    data['brand_id'] = brandId;
    data['unit'] = unit;
    data['min_qty'] = minQty;
    data['refundable'] = refundable;
    data['digital_product_type'] = digitalProductType;
    data['digital_file_ready'] = digitalFileReady;
    data['images'] = images;
    data['color_image'] = colorImage;
    data['thumbnail'] = thumbnail;
    data['thumbnail_storage_type'] = thumbnailStorageType;
    data['video_provider'] = videoProvider;
    data['colors'] = colors;
    data['variant_product'] = variantProduct;
    data['attributes'] = attributes;
    data['choice_options'] = choiceOptions;
    data['variation'] = variation;
    data['published'] = published;
    data['unit_price'] = unitPrice;
    data['purchase_price'] = purchasePrice;
    data['tax'] = tax;
    data['tax_type'] = taxType;
    data['tax_model'] = taxModel;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['current_stock'] = currentStock;
    data['minimum_order_qty'] = minimumOrderQty;
    data['details'] = details;
    data['free_shipping'] = freeShipping;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    data['featured_status'] = featuredStatus;
    data['meta_title'] = metaTitle;
    data['meta_description'] = metaDescription;
    data['request_status'] = requestStatus;
    data['shipping_cost'] = shippingCost;
    data['multiply_qty'] = multiplyQty;
    data['code'] = code;
    data['price_type'] = priceType;
    data['product_multi_price'] = productMultiPrice;
    data['is_shop_temporary_close'] = isShopTemporaryClose;
    if (imagesFullUrl != null) {
      data['images_full_url'] =
          imagesFullUrl!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Variation {
  String? variantType;
  double? variantPrice;
  int? quantity;
  double? priceRange;

  Variation(
      {this.variantType, this.variantPrice, this.quantity, this.priceRange});

  Variation.fromJson(Map<String, dynamic> json) {
    variantType = json['variant_type'];
    variantPrice = double.tryParse(json['variant_price'].toString());
    quantity = json['quantity'];
    priceRange = double.tryParse(json['price_range'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['variant_type'] = variantType;
    data['variant_price'] = variantPrice;
    data['quantity'] = quantity;
    data['price_range'] = priceRange;
    return data;
  }
}