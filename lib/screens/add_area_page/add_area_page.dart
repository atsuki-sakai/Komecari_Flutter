import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:komecari_project/helper/transparent_app_bar.dart';
import 'package:komecari_project/model/area.dart';
import 'package:komecari_project/model/komecari_user.dart';
import 'package:komecari_project/model/rice.dart';
import 'package:komecari_project/screens/add_rice_page/add_rice_page.dart';
import 'package:komecari_project/service/firestore_service.dart';
import 'package:komecari_project/service/path_generator.dart';
import 'package:komecari_project/service/storage_service.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class AddAreaPage extends StatefulWidget {
  final KomecariUser user;
  final Rice rice;
  final Area area;

  const AddAreaPage(
      {Key key, @required this.user, @required this.rice, this.area})
      : super(key: key);

  @override
  _AddAreaPageState createState() => _AddAreaPageState();
}

class _AddAreaPageState extends State<AddAreaPage> {
  final TextEditingController _prefectureController = TextEditingController();
  final TextEditingController _citiesController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _detailAddressController =
      TextEditingController();
  final TextEditingController _productAreaController = TextEditingController();

  final FocusNode _prefectureFocusNode = FocusNode();
  final FocusNode _citiesFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _detailAddressFocusNode = FocusNode();
  final FocusNode _productAreaFocusNode = FocusNode();

  Rice get rice => widget.rice;

  // TODO - 商品生産地　都道府県
  String produceArea = '';

  // TODO - 商品発送地域 **AreaクラスのIDを登録
  String get detailShippingArea => '';

  KomecariUser get user => widget.user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.area != null) {
      _prefectureController.text = widget.area.prefecture;
      _productAreaController.text = widget.area.prefecture;
      _citiesController.text = widget.area.cities;
      _addressController.text = widget.area.address;
      _detailAddressController.text = widget.area.detailAddress;
    }
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
              Text(
                '⑦ 生産地',
                style: headerTextStyle(),
              ),
              TextFormField(
                controller: _productAreaController,
                focusNode: _productAreaFocusNode,
                decoration: InputDecoration(hintText: '都道府県'),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                '⑧ 発送地域',
                style: headerTextStyle(),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                '都道府県',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12.0),
              ),
              TextFormField(
                controller: _prefectureController,
                focusNode: _prefectureFocusNode,
                decoration: InputDecoration(
                  hintText: '例：東京都、京都府',
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                '市町村',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12.0),
              ),
              TextFormField(
                controller: _citiesController,
                focusNode: _citiesFocusNode,
                decoration: InputDecoration(
                  hintText: '例：千代田区大手町、京都市下京区四条通',
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                '番地',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12.0),
              ),
              TextFormField(
                controller: _addressController,
                focusNode: _addressFocusNode,
                decoration: InputDecoration(
                  hintText: '例：1-7-3, 45-5',
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                '建物名',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12.0),
              ),
              TextFormField(
                controller: _detailAddressController,
                focusNode: _detailAddressFocusNode,
                decoration: InputDecoration(
                  hintText: '例：柳ビル　102号、ハイツ202号棟　2階',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // TODO -  Save  user shippingArea

                      final detailShippingArea = Area(
                          prefecture: _prefectureController.text,
                          cities: _citiesController.text,
                          address: _addressController.text,
                          detailAddress: _detailAddressController.text,
                          userId: user.uid);
                      await FirestoreService.instance.setData(
                          path: APIPath.area(userId: user.uid),
                          data: detailShippingArea.toMap());

                      rice.updateWith(
                          detailShippingArea:
                              '${detailShippingArea.prefecture} ${detailShippingArea.cities} ${detailShippingArea.address} ${detailShippingArea.detailAddress != null ? detailShippingArea.detailAddress : ''}');

                      user.updateWith(hasShippingArea: true);
                      await FirestoreService.instance.setData(
                          path: APIPath.user(userId: user.uid),
                          data: user.toMap());
                      rice.updateWith(
                        produceArea: _prefectureController.text,
                      );

                      await FirestoreService.instance.setData(
                          path: APIPath.rice(riceId: rice.uid),
                          data: rice.toMap());
                      print('5');
                      print('Completed');
                      Navigator.pop(context);
                      Navigator.pop(context);
                      // TODO - drawer も閉じるようにしたい
                    },
                    icon: Icon(
                      Icons.check_circle_outline,
                      size: 32,
                    ),
                    label: Text(
                      '商品を登録する',
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
