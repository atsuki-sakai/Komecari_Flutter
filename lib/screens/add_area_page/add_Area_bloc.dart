import 'dart:async';

import 'package:komecari_project/helper/custom_firebase_exception.dart';
import 'package:komecari_project/model/area.dart';
import 'package:komecari_project/model/komecari_user.dart';
import 'package:komecari_project/model/rice.dart';
import 'package:komecari_project/screens/add_area_page/add_area_model.dart';
import 'package:komecari_project/service/firestore_service.dart';
import 'package:komecari_project/service/path_generator.dart';
import 'package:komecari_project/service/storage_service.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rxdart/rxdart.dart';

class AddAreaBloc {
  final _modelSubject = BehaviorSubject<AddAreaModel>.seeded(AddAreaModel());

  Stream<AddAreaModel> get modelStream => _modelSubject.stream;

  StreamSink<AddAreaModel> get _modelState => _modelSubject.sink;

  AddAreaModel get _model => _modelSubject.value!;

  void updateProduceArea(String produceArea) =>
      updateWith(produceArea: produceArea);

  void updatePrefecture(String prefecture) =>
      updateWith(prefecture: prefecture);

  void updateCities(String cities) => updateWith(cities: cities);

  void updateAddress(String address) => updateWith(address: address);

  void updateDetailAddress(String detailAddress) =>
      updateWith(detailAddress: detailAddress);

  Future<List<String>> saveAssetsToUrls(
      {required List<Asset> assets, required String fileName}) async {
    final urls = await StorageService.instance
        .savedAssetsToUrls(assets: assets, fileName: fileName);
    return urls;
  }

  Future<void> saveUserShippingArea({required String userId}) async {
    final shippingArea = Area(
        prefecture: _model.prefecture,
        cities: _model.cities,
        address: _model.address,
        detailAddress: _model.detailAddress,
        userId: userId);
    await FirestoreService.instance.setData(
        path: APIPath.area(userId: userId), data: shippingArea.toMap());
  }

  Future<void> updateUser({required KomecariUser user}) async {
    await FirestoreService.instance
        .setData(path: APIPath.user(userId: user.uid), data: user.toMap());
  }

  void updateArea(Area area) {
    updateWith(
      produceArea: area.prefecture,
      prefecture: area.prefecture,
      cities: area.cities,
      address: area.address,
      detailAddress: area.detailAddress,
    );
  }

  void dispose() {
    _modelSubject.close();
  }

  void updateWith({
    String? prefecture,
    String? cities,
    String? address,
    String? detailAddress,
    String? produceArea,
    bool? isSubmited,
    bool? isLoading,
  }) {
    _modelSubject.add(
      _model.copyWith(
        prefecture: prefecture,
        cities: cities,
        address: address,
        detailAddress: detailAddress,
        productArea: produceArea,
        isSubmited: isSubmited,
        isLoading: isLoading,
      ),
    );
  }
}
