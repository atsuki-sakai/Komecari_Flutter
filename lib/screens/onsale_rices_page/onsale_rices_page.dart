import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:komecari_project/component/safe_scaffold.dart';

class OnSaleRicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      appBar: AppBar(
        title: Text('出品中の商品', style: GoogleFonts.montserrat(fontSize: 18.0, fontWeight: FontWeight.bold),),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: () {
          Navigator.pop(context);
        },),
      ),
      body: Center(child: Text('On Sale Rices Page'),),
    );
  }
}
