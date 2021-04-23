
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:komecari_project/screens/add_area_page/add_area_model.dart';
import 'package:komecari_project/screens/add_rice_page/add_rice_model.dart';
import 'package:uuid/uuid.dart';

class Rice {
  String _uid = '';
  String _sellerId = '';
  String _riceName = '';
  String _description = '';
  int _kg = 0;
  double _price = 0;
  List<String> _itemImages = [];
  String _produceArea = '';
  String _detailShippingArea = '';
  int _inStock = 0;
  List<String> _comments = [];

  String get uid => this._uid;

  String get sellerId => this._sellerId;

  String get riceName => this._riceName;

  String get description => this._description;

  int get kg => this._kg;

  double get price => this._price;

  List<String> get itemImages => this._itemImages;

  String get produceArea => this._produceArea;

  String get detailShippingArea => this._detailShippingArea;

  int get inStock => this._inStock;

  List<String> get comments => this._comments;

  bool get onSale => _inStock > 0 ? true : false;
  
  Rice.registerWithModel({required String sellerId ,required AddRiceModel riceModel, required AddAreaModel areaModel, required List<String> imageUrls}){
    this._uid = Uuid().v4();
    this._sellerId = sellerId;
    this._riceName = riceModel.riceName;
    this._description = riceModel.description;
    this._kg = riceModel.kg;
    this._price = riceModel.price;
    this._itemImages = imageUrls;
    this._produceArea = areaModel.prefecture;
    this._detailShippingArea = '${areaModel.prefecture}${areaModel.cities}${areaModel.address}${areaModel.detailAddress}';
    this._inStock = riceModel.inStock;
    // TODO - make commets class
    this._comments = [];
  }

  Rice({
    String? uid,
    String? riceName,
    String? sellerId,
    String? description,
    int? kg,
    double? price,
    String? produceArea,
    String? detailShippingArea,
    int? inStock,
    List<String>? itemImages,
    List<String>? comments,
  }) {
    _uid = uid ?? Uuid().v4();
    _sellerId = sellerId ?? '';
    _riceName = riceName ?? '';
    _description = description ?? '';
    _kg = kg ?? 0;
    _price = price ?? 0;
    _produceArea = produceArea ?? '';
    _detailShippingArea = detailShippingArea ?? '';
    _inStock = inStock ?? 0;
    _itemImages = itemImages ?? [];
    _comments = comments ?? [];
  }

  bool get riceNameValid => riceName.length < 40 && riceName.length > 0;

  bool get descriptionValid => description.length < 1000 && riceName.length > 0;

  bool get inputFormCompleted =>
      sellerId.isNotEmpty &&
      riceNameValid &&
      descriptionValid &&
      kg > 0 &&
      price > 0 &&
      produceArea.isNotEmpty &&
      _detailShippingArea.isNotEmpty &&
      inStock > 0 &&
      itemImages.length > 1;

  factory Rice.fromMap(Map<String, dynamic> data) {
    return Rice(
      uid: data['uid'],
      riceName: data['riceName'],
      sellerId: data['sellerId'],
      description: data['description'],
      kg: data['kg'],
      price: data['price'],
      produceArea: data['produceArea'],
      detailShippingArea: data['shippingArea'],
      inStock: data['inStock'],
      itemImages: data['itemImages'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'riceName': riceName,
      'sellerId': sellerId,
      'description': description,
      'kg': kg,
      'price': price,
      'produceArea': produceArea,
      'shippingArea': detailShippingArea,
      'isStock': inStock,
      'itemImages': itemImages,
    };
  }

  void updateWith({
    String? riceName,
    String? sellerId,
    String? description,
    int? kg,
    double? price,
    String? produceArea,
    String? detailShippingArea,
    int? inStock,
    List<String>? itemImages,
    List<String>? comments,
  }) {
    this._riceName = riceName ?? this.riceName;
    this._sellerId = sellerId ?? this.sellerId;
    this._description = description ?? this.description;
    this._kg = kg ?? this.kg;
    this._price = price ?? this.price;
    this._produceArea = produceArea ?? this.produceArea;
    this._itemImages = itemImages ?? this.itemImages;
    this._detailShippingArea =
        detailShippingArea ?? this.detailShippingArea;
    this._inStock = inStock ?? this.inStock;
    this._comments = comments ?? this.comments;
  }

  void addComments(String commentId) {
    this._comments.add(commentId);
  }
}
