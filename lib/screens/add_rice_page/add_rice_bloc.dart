import 'dart:async';
import 'package:komecari_project/screens/add_rice_page/add_rice_model.dart';
import 'package:komecari_project/service/storage_service.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rxdart/rxdart.dart';

class AddRiceBloc {
  final _modelSubject = BehaviorSubject<AddRiceModel>.seeded(AddRiceModel());

  Stream<AddRiceModel> get modelStream => _modelSubject.stream;

  StreamSink<AddRiceModel> get _modelState => _modelSubject.sink;

  void dispose() {
    _modelSubject.close();
  }

  AddRiceModel get _model => _modelSubject.value!;
  StorageService _storageService = StorageService.instance;

  Future<List<String>> savedImagesToUrls({required String riceId}) async {
    if(_model.assets == null || _model.assets == []) return [] ;
    final urls = await _storageService.savedAssetsToUrls(
        assets: _model.assets!, fileName: riceId);
    return urls;
  }

  Future<void> showPhotoLibrary() async {
    try {
      final results = await MultiImagePicker.pickImages(
        maxImages: 5,
        selectedAssets: _model.assets ?? [],
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: ('商品画像'),
          selectionFillColor: "#ff11ab",
          selectionTextColor: "#ffffff",
          selectionCharacter: "✓",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: 'KOMECARI',
          allViewTitle: 'All Photo',
          useDetailsView: false,
          selectCircleStrokeColor: '#000000',
        ),
      );
      updateWith(assets: results);
    } catch (e) {
      rethrow;
    }
  }

  void updateRiceName(String name) => updateWith(riceName: name);
  void updateDescription(String description) => updateWith(description: description);
  void updatePrice(String price) => updateWith(price: checkStrToNum(price) ? double.parse(price): 0.0);
  void updateInStock(String inStock) => updateWith(inStock: checkStrToNum(inStock) ? int.parse(inStock): 0);
  void updateKg(String kg) => updateWith(kg: checkStrToNum(kg) ? int.parse(kg): 0);

  bool checkStrToNum(String value) {
    try{
      num.parse(value);
      return true;
    }catch(_){
      return false;
    }
  }
  

  void updateWith({
    String? riceName,
    List<Asset>? assets,
    String? sellerId,
    String? description,
    int? kg,
    double? price,
    int? inStock,
    bool? isSubmit,
    bool? isLoading,
  }) {
    _modelSubject.add(_model.copyWith(
      riceName: riceName,
      assets: assets,
      sellerId: sellerId,
      description: description,
      kg: kg,
      price: price,
      inStock: inStock,
      isSubmit: isSubmit,
      isLoading: isLoading,
    ));
  }
}
