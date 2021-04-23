import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:komecari_project/component/alert_dialog.dart';
import 'package:komecari_project/helper/transparent_app_bar.dart';
import 'package:komecari_project/model/area.dart';
import 'package:komecari_project/model/komecari_user.dart';
import 'package:komecari_project/screens/add_area_page/add_area_page.dart';
import 'package:komecari_project/screens/add_rice_page/add_rice_bloc.dart';
import 'package:komecari_project/screens/add_rice_page/add_rice_model.dart';
import 'package:komecari_project/service/firestore_service.dart';
import 'package:komecari_project/service/path_generator.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class AddRicePage extends StatefulWidget {
  final KomecariUser user;
  final AddRiceBloc bloc;

  const AddRicePage({Key? key,required this.user,required this.bloc}) : super(key: key);

  static Widget create(BuildContext context, {required KomecariUser user}) {
    return Provider<AddRiceBloc>(
      create: (_) => AddRiceBloc(),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<AddRiceBloc>(
        builder: (_, bloc, __) {
          return AddRicePage(
            user: user,
            bloc: bloc,
          );
        },
      ),
    );
  }

  @override
  _AddRicePageState createState() => _AddRicePageState();
}

class _AddRicePageState extends State<AddRicePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _inStockController = TextEditingController();
  final TextEditingController _kgController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _inStockFocusNode = FocusNode();
  final FocusNode _kgFocusNode = FocusNode();

  Future<void> _transitionAddAreaPage(AddRiceModel model) async {
    widget.bloc.updateWith(isLoading: true, isSubmit: true);
    if(model.inputFormValid()) {
      try {
        final Area? area = await getUserShippingArea();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AddAreaPage.create(
              context, user: widget.user, riceModel: model,area: area);
        }));
      } catch (e) {
        print('Error Type : ${e.runtimeType}');
        print(e);
      } finally {
        widget.bloc.updateWith(isLoading: false);
      }
    }else{
      await showAlertDialog(context, title: '入力エラー', content: '入力値に誤りがあります。確認の上もう一度お試しください。', defaultActionText: 'OK');
      widget.bloc.updateWith(isLoading: false);
    }
  }

  Future<Area?> getUserShippingArea() async {
    if (widget.user.hasShippingArea) {
      final snapShot = await FirestoreService.instance
          .getData(path: APIPath.area(userId: widget.user.uid));
      final Area? area = Area.fromMap(snapShot.data()!);
      return area;
    } else {
      return null;
    }
  }

  Future<void> _selectedImages() async {
    try {
      await widget.bloc.showPhotoLibrary();
    } catch (e) {
      print('Error Type : ${e.runtimeType}');
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _inStockController.clear();
    _kgController.clear();
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _inStockFocusNode.dispose();
    _kgFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TransParentAppBar(
        title: '商品情報の登録',
        color: Colors.grey.shade50,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 22.0),
        child: SingleChildScrollView(
          child: StreamBuilder<AddRiceModel>(
              stream: widget.bloc.modelStream,
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  print(snapshot.error);
                }
                final _model = snapshot.data;
                if(_model == null) return Center(child: CircularProgressIndicator());
                return Column(
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
                        _buildAddPhotoButton(),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    if (_model.assets != null) ...{
                      _buildShowRicesGridView(_model),
                    } else ...{
                      _buildEmptyImage(),
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
                    _buildRiceNameTextField(_model),
                    SizedBox(
                      height: 20.0,
                    ),
                    // 商品説明
                    Text(
                      '③ 商品説明',
                      style: headerTextStyle(),
                    ),
                    _buildDescriptionTextField(_model),
                    SizedBox(
                      height: 10.0,
                    ),
                    // 値段
                    Text(
                      '④ 値段',
                      style: headerTextStyle(),
                    ),
                    _buildPriceTextField(_model),
                    SizedBox(
                      height: 20.0,
                    ),
                    // 在庫数
                    Text(
                      '⑤ 在庫数',
                      style: headerTextStyle(),
                    ),
                    _buildInStockTextField(_model),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '⑥ 重さ',
                      style: headerTextStyle(),
                    ),
                    _buildWeightTextField(_model),
                    SizedBox(
                      height: 10,
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    nextStepButton(_model),
                    SizedBox(
                      height: 200,
                    ),
                  ],
                );
              },
          ),
        ),
      ),
    );
  }

  SizedBox nextStepButton(AddRiceModel model) {
    return SizedBox(
        height: 60,
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: model.isLoading ? null :() => _transitionAddAreaPage(model),
          icon: Icon(
            Icons.check_circle_outline,
            size: 32,
          ),
          label: Text(
            '入力完了',
            style:
                GoogleFonts.notoSans(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ));
  }

  TextFormField _buildWeightTextField(AddRiceModel model) {
    return TextFormField(
      keyboardType: TextInputType.datetime,
      controller: _kgController,
      focusNode: _kgFocusNode,
      onChanged: widget.bloc.updateKg,
      onEditingComplete: () => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        hintText: '一つあたりの重量（Kg,数字のみ）',
        errorText: model.kgInputError ? model.kgErrorText : null,
      ),
    );
  }

  TextFormField _buildInStockTextField(AddRiceModel model) {
    return TextFormField(
      keyboardType: TextInputType.datetime,
      controller: _inStockController,
      focusNode: _inStockFocusNode,
      onChanged: widget.bloc.updateInStock,
      onEditingComplete: () => FocusScope.of(context).requestFocus(_kgFocusNode),
      decoration: InputDecoration(
        hintText: '在庫数（数字のみ）',
        errorText: model.inStockInputError ? model.inStockErrorText : null,
      ),
    );
  }

  TextFormField _buildPriceTextField(AddRiceModel model) {
    return TextFormField(
      keyboardType: TextInputType.datetime,
      controller: _priceController,
      focusNode: _priceFocusNode,
      onChanged: widget.bloc.updatePrice,
      onEditingComplete: () => FocusScope.of(context).requestFocus(_inStockFocusNode),
      decoration: InputDecoration(
        hintText: '価格（数字のみ）',
        errorText: model.priceInputError ? model.priceErrorText : null,
      ),
    );
  }

  SizedBox _buildDescriptionTextField(AddRiceModel model) {
    final config = KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardSeparatorColor: Colors.transparent,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(focusNode: _descriptionFocusNode, toolbarButtons: [
          (node) {
            return TextButton(
              onPressed: node.unfocus,
              child: Text('閉じる'),
            );
          }
        ]),
      ],
    );
    return SizedBox(
      height: 200,
      child: KeyboardActions(
        config: config,
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          controller: _descriptionController,
          focusNode: _descriptionFocusNode,
          minLines: 8,
          maxLines: 50,
          maxLength: 1000,
          onChanged: widget.bloc.updateDescription,
          onEditingComplete: () => FocusScope.of(context).requestFocus(_priceFocusNode),
          decoration: InputDecoration(
            hintText: '商品紹介文（1000文字まで）',
            errorText: model.descriptionInputError ? model.descriptionErrorText : null,
          ),
        ),
      ),
    );
  }

  SizedBox _buildAddPhotoButton() {
    return SizedBox(
      height: 30,
      width: 100,
      child: ElevatedButton(
          child: Text(
            '写真を追加',
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
          ),
          onPressed: _selectedImages),
    );
  }

  TextFormField _buildRiceNameTextField(AddRiceModel model) {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: _nameController,
      focusNode: _nameFocusNode,
      onChanged: widget.bloc.updateRiceName,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_descriptionFocusNode),
      decoration: InputDecoration(
        hintText: '商品名（40文字まで）',
        errorText: model.nameInputError ? model.nameErrorText : null,
      ),
    );
  }

  SizedBox _buildShowRicesGridView(AddRiceModel _model) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisSpacing: 8.0,
        crossAxisCount: 5,
        children: List.generate(_model.assets!.length, (index) {
          Asset _asset = _model.assets![index];
          // TODO - 画像をタップして編集出来る様に変更する。
          return AssetThumb(asset: _asset, width: 120, height: 120);
        }),
      ),
    );
  }

  Stack _buildEmptyImage() {
    return Stack(
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
                fontSize: 12.0, color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  TextStyle headerTextStyle() {
    return GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w600);
  }
}
