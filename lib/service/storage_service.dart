import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as IMG;
import 'package:komecari_project/service/path_generator.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();

  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> _temporaryDictPath() async {
    final tempDir = await getTemporaryDirectory();
    return tempDir.path;
  }

  Future<File> _complessFile(
      {required File file,
      required int size,
      required String fileName,
      int quality = 85}) async {
    // ImagePickerで取得した画像の保存先のディレクトリを取得
    final tempPath = await _temporaryDictPath();
    // TODO - awaitが要らないと出るので消した
    final byte =  file.readAsBytesSync();
    final IMG.Image image = IMG.decodeImage(byte)!;
    final IMG.Image thumbnail =
        IMG.copyResize(image, width: size, height: size);
    //IMG.Image型からFileを作成
    return File('$tempPath/$fileName.jpeg')
      ..writeAsBytesSync(IMG.encodeJpg(thumbnail, quality: quality));
  }

  Future<String> uploadFile({
    required File file,
    required String path,
    int quality = 85,
    int size = 120,
  }) async {
    final _ref = _storage.ref(path);
    // path = 'profiles/*userId*'
    var compressedImage = await _complessFile(
        file: file, size: size, quality: quality, fileName: path.split('/').last);
    final task = await _ref.putFile(compressedImage);
    return Future.value(task.ref.getDownloadURL());
  }

  Future<String> downloadImageLink({
    required String path,
  }) async {
    final url = await _storage.ref(path).getDownloadURL();
    return url;
  }

  Future<File> assetToFile({required Asset asset,required String fileName, int? index}) async {
    final tempPath = await _temporaryDictPath();
    ByteData byteData = await asset.getByteData();
    List<int> imageData = byteData.buffer.asUint8List();
    final imageFile = File('$tempPath/$fileName${index != null ? '_$index' : null}.jpeg')
      ..writeAsBytesSync(imageData);
    return imageFile;
  }

  Future<List<String>> savedAssetsToUrls({required List<Asset> assets, required String fileName}) async {
    List<String> results = [];
    int index = 1;
    for (var asset in assets) {
      final _riceImageFile = await assetToFile(asset: asset, fileName: fileName, index: index);
      final _path = APIPath.rice(riceId: '${fileName}_$index');
      final _url = await uploadFile(
          quality: 85,
          size: 900,
          file: _riceImageFile,
          path: _path,
      );
      results.add(_url);
      index = index + 1;
    }
    return results;
  }
}
