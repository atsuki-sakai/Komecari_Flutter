import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:komecari_project/helper/transparent_app_bar.dart';
import 'package:komecari_project/model/area.dart';
import 'package:komecari_project/model/komecari_user.dart';
import 'package:komecari_project/model/rice.dart';
import 'package:komecari_project/screens/add_area_page/add_area_page.dart';
import 'package:komecari_project/service/firestore_service.dart';
import 'package:komecari_project/service/path_generator.dart';
import 'package:komecari_project/service/storage_service.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final area = ['OSAKA', 'TOKYO', 'AICHI', 'FUKUOKA'];

//
// String _uid;
// String _sellerId;
// String _riceName;
// String _description;
// int _kg,
// double _price;
// List<String> _itemImages;
// String _produceAreaId;
// String _shippingAreaId;
// int _inStock;
// List<String> _comments;

class AddRicePage extends StatefulWidget {
  final KomecariUser user;

  const AddRicePage({Key key, this.user}) : super(key: key);

  @override
  _AddRicePageState createState() => _AddRicePageState();
}

class _AddRicePageState extends State<AddRicePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _inStockController = TextEditingController();
  final TextEditingController _kgController = TextEditingController();
  final TextEditingController _prefectureController = TextEditingController();
  final TextEditingController _citiesController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _detailAddressController =
      TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _inStockFocusNode = FocusNode();
  final FocusNode _kgFocusNode = FocusNode();
  final FocusNode _prefectureFocusNode = FocusNode();
  final FocusNode _citiesFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _detailAddressFocusNode = FocusNode();

  List<Asset> images = [];

  String get description => _descriptionController.text;

  int get kg => int.parse(_kgController.text);

  double get price => double.parse(_priceController.text);

  // TODO - 商品生産地　都道府県
  String produceArea = '';

  // TODO - 商品発送地域 **AreaクラスのIDを登録
  String get detailShippingArea => '';

  int get inStock => int.parse(_inStockController.text);

  // TODO - Storageに保存したURLを保存する
  List<String> get riceImages => [];

  KomecariUser get user => widget.user;

  Future<List<String>> saveAssets({List<Asset> assets, String riceId}) async {
    List<String> results = [];
    var index = 1;
    for (var asset in assets) {
      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;
      ByteData byteData = await asset.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      final riceImageFile = File('$tempPath/${riceId}_$index.jpeg')
        ..writeAsBytesSync(imageData);
      final url = await StorageService.instance.uploadFile(
          quality: 85,
          size: 900,
          file: riceImageFile,
          path: APIPath.rice(
            riceId: '${riceId}_$index',
          ));
      results.add(url);
      index = index + 1;
    }
    return results;
  }

  void _registerRice() async {
    final Rice newRice = Rice(
      uid: Uuid().v4(),
      sellerId: user.uid,
      description: description,
      kg: kg,
      price: price,
      inStock: inStock,
    );

    final urls = await saveAssets(assets: images, riceId: newRice.uid);
    newRice.updateWith(itemImages: urls);
    Area area;
    if (user.hasShippingArea) {
      final snapShot = await FirestoreService.instance
          .getData(path: APIPath.area(userId: user.uid));
      area = Area.fromMap(snapShot.data());
    } else {
      print('not have area');
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddAreaPage(
        user: user,
        rice: newRice,
        area: area,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildTransparentAppBar(title: '商品登録', color: Colors.grey.shade50),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 22.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '① 商品画像',
                    style: headerTextStyle(),
                  ),
                  SizedBox(
                    width: 30.0,
                  ),
                  SizedBox(
                    height: 30,
                    width: 100,
                    child: ElevatedButton(
                      child: Text('写真を追加',
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        var results = [];
                        try {
                          results = await MultiImagePicker.pickImages(
                            maxImages: 5,
                            selectedAssets: images,
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
                        } catch (e) {
                          print(e.toString());
                        }
                        setState(() {
                          images = results;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              if (images.isNotEmpty) ...{
                SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 8.0,
                    crossAxisCount: 5,
                    children: List.generate(images.length, (index) {
                      Asset _asset = images[index];
                      // TODO - 画像をタップして編集出来る様に変更する。
                      return AssetThumb(asset: _asset, width: 120, height: 120);
                    }),
                  ),
                ),
              } else ...{
                Stack(
                  children: [
                    Icon(
                      Icons.photo_size_select_actual_outlined,
                      size: 80,
                      color: Colors.grey.shade300,
                    ),
                    Positioned(
                        bottom: 12,
                        child: Text(
                          '写真を追加\n　して下さい。',
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              },
              Divider(
                color: Colors.grey.shade500,
                thickness: 1,
              ),
              SizedBox(
                height: 12.0,
              ),
              // 商品名
              Text(
                '② 商品名',
                style: headerTextStyle(),
              ),
              SizedBox(
                height: 40,
                child: TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  decoration: InputDecoration(hintText: '商品名（30文字まで）'),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              // 商品説明
              Text(
                '③ 商品説明',
                style: headerTextStyle(),
              ),
              SizedBox(
                height: 200,
                child: KeyboardActions(
                  config: KeyboardActionsConfig(
                      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
                      keyboardSeparatorColor: Colors.transparent,
                      nextFocus: false,
                      actions: [
                        KeyboardActionsItem(
                            focusNode: _descriptionFocusNode,
                            toolbarButtons: [
                              (node) {
                                return TextButton(
                                    onPressed: () {
                                      node.unfocus();
                                    },
                                    child: Text('閉じる'));
                              }
                            ]),
                      ]),
                  child: TextFormField(
                    controller: _descriptionController,
                    focusNode: _descriptionFocusNode,
                    minLines: 8,
                    maxLines: 50,
                    maxLength: 1000,
                    decoration: InputDecoration(
                      hintText: '商品紹介文（1000文字まで）',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              // 値段
              Text(
                '④ 値段',
                style: headerTextStyle(),
              ),
              TextFormField(
                controller: _priceController,
                focusNode: _priceFocusNode,
                decoration: InputDecoration(
                  hintText: '価格（数字のみ）',
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              // 在庫数
              Text(
                '⑤ 在庫数',
                style: headerTextStyle(),
              ),
              TextFormField(
                controller: _inStockController,
                focusNode: _inStockFocusNode,
                decoration: InputDecoration(
                  hintText: '在庫数（数字のみ）',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '⑥ 重さ',
                style: headerTextStyle(),
              ),
              TextFormField(
                controller: _kgController,
                focusNode: _kgFocusNode,
                decoration: InputDecoration(
                  hintText: '一つあたりの重量（Kg,数字のみ）',
                ),
              ),
              SizedBox(
                height: 10,
              ),

              SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _registerRice,
                    icon: Icon(
                      Icons.check_circle_outline,
                      size: 32,
                    ),
                    label: Text(
                      '次へ',
                      style: GoogleFonts.notoSans(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  )),
              SizedBox(
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle headerTextStyle() {
    return GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w600);
  }
}
