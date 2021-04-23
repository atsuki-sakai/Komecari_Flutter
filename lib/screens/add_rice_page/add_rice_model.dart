import 'package:komecari_project/model/area.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AddRiceModel {
  AddRiceModel({
    this.riceName = '',
    this.assets,
    this.sellerId = '',
    this.description = '',
    this.kg = 0,
    this.price = 0,
    this.inStock = 0,
    this.isSubmit = false,
    this.isLoading = false,
  });

  String riceName;
  List<Asset>? assets;
  List<String>? urls;
  String sellerId;
  String description;
  int kg;
  double price;
  int inStock;

  bool isSubmit;
  bool isLoading;


  bool get nameInputError =>
      isSubmit == true && (riceName.isEmpty || riceName.length > 40);
  final String nameErrorText = '商品名が空または40字以上です。';

  bool get descriptionInputError =>
      isSubmit == true && (description.isEmpty || description.length > 1000);
  final String descriptionErrorText = '商品説明が空または1000字以上です。';

  bool get priceInputError =>
      isSubmit == true &&
      (price < 1 || price > 1000000);
  final String priceErrorText = '商品価格は数字のみで、1〜100万円の範囲で指定する。';

  bool get inStockInputError =>
      isSubmit == true && (inStock < 1 || inStock > 500);
  final String inStockErrorText = '在庫数は数字のみで、1〜500個の範囲で指定する。';

  bool get kgInputError => isSubmit == true && (kg < 1 || kg > 30);
  final String kgErrorText = '重さは数字のみで、1〜30kgの範囲内で指定する。';

  bool inputFormValid() {
    return riceName.isNotEmpty && riceName.length < 40 &&
        description.isNotEmpty && description.length < 1000 &&
        price > 1 && price < 1000000 &&
        inStock > 1 && inStock < 500 &&
        kg > 1 && kg < 30 &&
    assets != null
    ;
  }

  AddRiceModel copyWith({
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
    return AddRiceModel(
      riceName: riceName ?? this.riceName,
      assets: assets ?? this.assets,
      sellerId: sellerId ?? this.sellerId,
      description: description ?? this.description,
      kg: kg ?? this.kg,
      price: price ?? this.price,
      inStock: inStock ?? this.inStock,
      isSubmit: isSubmit ?? this.isSubmit,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
