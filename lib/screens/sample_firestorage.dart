import 'dart:io';
import 'package:image/image.dart';
import 'package:flutter/material.dart';
import 'package:komecari_project/component/alert_dialog.dart';
import 'package:komecari_project/component/safe_scaffold.dart';
import 'package:komecari_project/service/path_generator.dart';
import 'package:komecari_project/service/storage_service.dart';
import 'package:image_picker/image_picker.dart';
class SampleStorage extends StatefulWidget {
  @override
  _SampleStorageState createState() => _SampleStorageState();
}

class _SampleStorageState extends State<SampleStorage> {
  File image;
  ImagePicker picker  = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      body: Column(
        children: [
          TextButton(onPressed: () async {
            final pickerFile = await picker.getImage(source: ImageSource.camera);
            setState(() {
              if (pickerFile != null) {
                image = File(pickerFile.path);
              }
            });
          }, child: Text('add file')),
          SizedBox(height: 100,),
          TextButton(onPressed: () async {
            try {
              await StorageService.instance.uploadFile(file: image,
                  path: StoragePath.profile(userId: 'resize_image_2'), size: 200, quality: 100);
            }catch(e){
              print(e.toString());
            }
          }, child: Text('save')),
          TextButton(onPressed: () async {
            await StorageService.instance.downloadImageLink(path: StoragePath.profile(userId: 'useruid_420'));

          }, child: Text('get image')),
        ],
      ),
    );;
  }
}
