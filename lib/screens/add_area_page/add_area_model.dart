import 'package:flutter/material.dart';

class AddAreaModel {
  AddAreaModel({
    this.prefecture = '',
    this.cities = '',
    this.address = '',
    this.detailAddress = '',
    this.produceArea = '',
    this.isSubmited = false,
    this.isLoading = false,
  });

  String prefecture;
  String cities;
  String address;
  String detailAddress;
  String produceArea;

  bool isLoading;
  bool isSubmited;

  bool get produceAreaInputError =>
      (produceArea.isEmpty || produceArea.length > 20) && isSubmited == true;
  final String produceAreaErrorText = '生産地が空または長すぎます。';

  bool get prefectureInputError =>
      (prefecture.isEmpty || prefecture.length > 20) && isSubmited == true;
  final String preffectureErrorText = '都道府県が空または長すぎます。';

  bool get citiesInputError =>
      (cities.isEmpty || cities.length > 20) && isSubmited == true;
  final String citiesErrorText = '市町村名が空または長すぎます。';

  bool get addressInputError =>
      (address.isEmpty || address.length > 20) && isSubmited == true;
  final String addressErrorText = '番地、号が空または長すぎます。';

  bool get detailAddressInputError =>
      detailAddress.length > 60 && isSubmited == true;
  final String detailAddressErrorText = '詳細住所が長すぎます。';

  bool inputFormValid() {
    return prefecture.isNotEmpty &&
        prefecture.length < 20 &&
        cities.isNotEmpty &&
        cities.length < 20 &&
        address.isNotEmpty &&
        address.length < 20 &&
        detailAddress.length < 60;
  }

  AddAreaModel copyWith({
    String? prefecture,
    String? cities,
    String? address,
    String? detailAddress,
    String? productArea,
    bool? isSubmited,
    bool? isLoading,
  }) {
    return AddAreaModel(
      prefecture: prefecture ?? this.prefecture,
      cities: cities ?? this.cities,
      address: address ?? this.address,
      detailAddress: detailAddress ?? this.detailAddress,
      produceArea: productArea ?? this.produceArea,
      isSubmited: isSubmited ?? this.isSubmited,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
