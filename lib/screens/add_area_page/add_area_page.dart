import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:komecari_project/component/alert_dialog.dart';
import 'package:komecari_project/helper/transparent_app_bar.dart';
import 'package:komecari_project/model/area.dart';
import 'package:komecari_project/model/komecari_user.dart';
import 'package:komecari_project/model/rice.dart';
import 'package:komecari_project/screens/add_area_page/add_Area_bloc.dart';
import 'package:komecari_project/screens/add_area_page/add_area_model.dart';
import 'package:komecari_project/screens/add_rice_page/add_rice_model.dart';
import 'package:komecari_project/screens/base_page/base_page.dart';
import 'package:komecari_project/service/firestore_service.dart';
import 'package:komecari_project/service/path_generator.dart';
import 'package:provider/provider.dart';

class AddAreaPage extends StatefulWidget {
  const AddAreaPage({
    Key? key,
    required this.user,
    required this.riceModel,
    required this.bloc,
    this.area,
  }) : super(key: key);
  final KomecariUser user;
  final AddRiceModel riceModel;
  final AddAreaBloc bloc;
  final Area? area;

  static Widget create(BuildContext conext,
      {required KomecariUser user,
      required AddRiceModel riceModel,
      Area? area}) {
    return Provider<AddAreaBloc>(
      create: (_) => AddAreaBloc(),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<AddAreaBloc>(
        builder: (_, bloc, __) {
          return AddAreaPage(
            user: user,
            riceModel: riceModel,
            bloc: bloc,
            area: area,
          );
        },
      ),
    );
  }

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

  Future<void> saveShippingArea() async {
    try {
      await widget.bloc.saveUserShippingArea(userId: widget.user.uid);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> saveAssetsToUrls() async {
    List<String> results = [];
    try {
      results = await widget.bloc.saveAssetsToUrls(
          assets: widget.riceModel.assets!,
          fileName: widget.riceModel.riceName);
      return results;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveRice(Rice rice) async {
    try {
      await FirestoreService.instance
          .setData(path: APIPath.rice(riceId: rice.uid), data: rice.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserData({required KomecariUser user}) async {
    try {
      widget.user.updateWith(hasShippingArea: true);
      await widget.bloc.updateUser(user: user);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(AddAreaModel model) async {
    widget.bloc.updateWith(isLoading: true, isSubmited: true);
    if (model.inputFormValid()) {
      try {
        await saveShippingArea();
        await updateUserData(user: widget.user);
        final urls = await saveAssetsToUrls();
        Rice newRice = Rice.registerWithModel(
          sellerId: widget.user.uid,
          riceModel: widget.riceModel,
          areaModel: model,
          imageUrls: urls,
        );
        await saveRice(newRice);
        // TODO - LaunchProvidersは必要
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return BasePage.launchProviders(context);
        }), (route) => false);
      } catch (e) {
        print(e.runtimeType);
        print(e);
      }finally{
        widget.bloc.updateWith(isLoading: false);
      }
    } else {
      await showAlertDialog(context,
          title: '入力エラー',
          content: '入力値に誤りがあります、再度確認の上登録してください。',
          defaultActionText: 'OK');
      widget.bloc.updateWith(isLoading: false);
    }
  }

  void updateShippingArea() {
    if (widget.area != null) {
      _productAreaController.text = widget.area!.prefecture;
      _prefectureController.text = widget.area!.prefecture;
      _citiesController.text = widget.area!.cities;
      _addressController.text = widget.area!.address;
      _detailAddressController.text = widget.area!.detailAddress;
      widget.bloc.updateArea(widget.area!);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateShippingArea();
  }

  @override
  void dispose() {
    super.dispose();
    _prefectureController.dispose();
    _citiesController.dispose();
    _addressController.dispose();
    _detailAddressController.dispose();
    _productAreaController.dispose();

    _prefectureFocusNode.dispose();
    _citiesFocusNode.dispose();
    _addressFocusNode.dispose();
    _detailAddressFocusNode.dispose();
    _productAreaFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TransParentAppBar(title: '発送情報の登録', color: Colors.grey.shade50),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 22.0),
        child: SingleChildScrollView(
          child: StreamBuilder<AddAreaModel>(
              stream: widget.bloc.modelStream,
              builder: (context, snapshot) {
                if (snapshot.data == null)
                  return Center(child: CircularProgressIndicator());
                final _model = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 22,),
                    Text(
                      '⑦ 生産地',
                      style: headerTextStyle(),
                    ),
                    _buildProduceAreaTextField(_model),
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
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 12.0),
                    ),
                    _buildPrefectureTextField(_model),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      '市町村',
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 12.0),
                    ),
                    _buildCitiesTextField(_model),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      '番地',
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 12.0),
                    ),
                    _buildAddressTextField(_model),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      '建物名',
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 12.0),
                    ),
                    _buildDetailTextField(_model),
                    SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _model.isLoading ? null : () => register(_model),
                              icon: Icon(
                                Icons.check_circle_outline,
                                size: 32,
                              ),
                              label: Text(
                                '商品を登録する',
                                style: GoogleFonts.notoSans(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),),
                        if(_model.isLoading)...{
                          Center(child: CircularProgressIndicator(),),
                        }
                      ],
                    ),
                    SizedBox(
                      height: 200,
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  TextFormField _buildDetailTextField(AddAreaModel model) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _detailAddressController,
      focusNode: _detailAddressFocusNode,
      onChanged: widget.bloc.updateDetailAddress,
      onEditingComplete: () => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        hintText: '任意：柳ビル　102号',
        errorText:
            model.detailAddressInputError ? model.detailAddressErrorText : null,
      ),
    );
  }

  TextFormField _buildAddressTextField(AddAreaModel model) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _addressController,
      focusNode: _addressFocusNode,
      onChanged: widget.bloc.updateAddress,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_detailAddressFocusNode),
      decoration: InputDecoration(
        hintText: '例：1-7-3, 45-5',
        errorText: model.addressInputError ? model.addressErrorText : null,
      ),
    );
  }

  TextFormField _buildCitiesTextField(AddAreaModel model) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _citiesController,
      focusNode: _citiesFocusNode,
      onChanged: widget.bloc.updateCities,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_addressFocusNode),
      decoration: InputDecoration(
        hintText: '例：千代田区大手町、京都市下京区四条通',
        errorText: model.citiesInputError ? model.citiesErrorText : null,
      ),
    );
  }

  TextFormField _buildPrefectureTextField(AddAreaModel model) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _prefectureController,
      focusNode: _prefectureFocusNode,
      onChanged: widget.bloc.updatePrefecture,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_citiesFocusNode),
      decoration: InputDecoration(
        hintText: '例：東京都、京都府',
        errorText:
            model.prefectureInputError ? model.preffectureErrorText : null,
      ),
    );
  }

  TextFormField _buildProduceAreaTextField(AddAreaModel model) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _productAreaController,
      focusNode: _productAreaFocusNode,
      onChanged: widget.bloc.updateProduceArea,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_prefectureFocusNode),
      decoration: InputDecoration(
        hintText: '都道府県',
        errorText:
            model.produceAreaInputError ? model.produceAreaErrorText : null,
      ),
    );
  }

  TextStyle headerTextStyle() {
    return GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w600);
  }
}
