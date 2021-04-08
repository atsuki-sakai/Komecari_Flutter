import 'package:flutter/material.dart';

class SellerInfomation {
  SellerInfomation({
    @required String sellerId,
    @required String shopName,
    List<String> onSaleingRices,
  }) {
    _sellerId = sellerId;
    _shopName = shopName;
    _onSelleringRices = onSaleingRices ?? [];
  }

  String _sellerId;
  String _shopName;
  List<String> _onSelleringRices = [];

  String get sellerId => _sellerId;
  String get shopName => _shopName;
  List<String> get onSelleringRices => _onSelleringRices;

  factory SellerInfomation.fromMap(Map<String, dynamic> data) {
    return SellerInfomation(
      sellerId: data['sellerId'],
      shopName: data['shopName'],
      onSaleingRices: data['onSelleringRices'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'shopName': shopName,
      'onSelleringRices': onSelleringRices,
    };
  }

  void productRegistration({@required String riceID}) {
    _onSelleringRices.insert(0, riceID);
  }
}
