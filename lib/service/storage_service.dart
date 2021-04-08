import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as IMG;
import 'package:path_provider/path_provider.dart';

class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();

  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<File> _complessFile(
      {@required File file,
      @required int size,
      @required String fileName,
      int quality = 85}) async {
    // ImagePickerで取得した画像の保存先のディレクトリを取得
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    final byte = await file.readAsBytesSync();
    final IMG.Image image = IMG.decodeImage(byte);
    final IMG.Image thumbnail =
        IMG.copyResize(image, width: size, height: size);
    //IMG.Image型からFileを作成
    return File('$tempPath/${fileName}.jpeg')
      ..writeAsBytesSync(IMG.encodeJpg(thumbnail, quality: quality));
  }

  Future<dynamic> uploadFile({
    @required File file,
    @required String path,
    int quality = 85,
    int size = 200,
  }) async {
    final _ref = _storage.ref(path);
    // path = 'profiles/*userId*'
    var compressedImage = await _complessFile(
        file: file, size: 100, fileName: path.split('/').last);
    await _ref.putFile(compressedImage);
  }

  Future<String> downloadImageLink({
    @required @required String path,
  }) async {
    final url = await _storage.ref(path).getDownloadURL();
    return url;
  }
}
