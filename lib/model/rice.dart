import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Rice {
  String _uid;
  String _sellerId;
  String _riceName;
  String _description;
  double _price;
  List<String> _itemImages;
  String _produceAreaId;
  String _shippingAreaId;
  int _inStock;
  List<String> _comments;

  String get uid => this._uid;
  String get sellerId => this._sellerId;
  String get riceName => this._riceName;
  String get description => this._description;
  double get price => this._price;
  List<String> get itemImages => this._itemImages;
  String get produceAreaId => this._produceAreaId;
  String get shippingAreaId => this._shippingAreaId;
  int get inStock => this._inStock;
  List<String> get comments => this._comments;
  bool get onSale => _inStock > 0 ? true : false;

  Rice({
    @required String sellerId,
    @required String description,
    @required double price,
    @required String produceAreaId,
    @required String shippingAreaId,
    @required int inStock,
    @required List<String> itemImages,
    List<String> comments,
  }) {
    _uid = Uuid().v4();
    _sellerId = sellerId;
    _riceName = riceName;
    _description = description;
    _price = price;
    _produceAreaId = produceAreaId;
    _shippingAreaId = shippingAreaId;
    _inStock = inStock;
    _itemImages = itemImages;
    _comments = comments ?? [];
  }

  factory Rice.fromMap(Map<String, dynamic> data) {
    return Rice(
      sellerId: data['sellerId'],
      description: data['description'],
      price: data['price'],
      produceAreaId: data['produceAreaId'],
      shippingAreaId: data['shippingAreaId'],
      inStock: data['inStock'],
      itemImages: data['itemImages'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'description': description,
      'price': price,
      'produceAreaId': produceAreaId,
      'shippingAreaId': shippingAreaId,
      'isStock': inStock,
      'itemImages': itemImages,
    };
  }

  void addComments(String commentId) {
    this._comments.add(commentId);
  }
}
