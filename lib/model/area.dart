
import 'package:uuid/uuid.dart';

List<String> prefectures  =  [
  '北海道',
  '青森',
  '岩手',
  '宮城',
  '秋田',
  '山形',
  '福島',
  '茨城',
  '栃木',
  '群馬',
  '埼玉',
  '千葉',
  '東京',
  '神奈川',
  '新潟',
  '富山',
  '石川',
  '福井',
  '山梨',
  '長野',
  '岐阜',
  '静岡',
  '愛知',
  '三重',
  '滋賀',
  '京都',
  '大阪',
  '兵庫',
  '奈良',
  '和歌山',
  '鳥取',
  '島根',
  '岡山',
  '広島',
  '山口',
  '徳島',
  '香川',
  '愛媛',
  '高知',
  '福岡',
  '佐賀',
  '長崎',
  '熊本',
  '大分',
  '宮崎',
  '鹿児島',
  '沖縄',
];


class Area {
  String userId = '';
  String prefecture = '';
  String cities = '';
  String address = '';
  String detailAddress = '';

  Area({
    this.userId = '',
    this.prefecture = '',
    this.cities = '',
    this.address = '',
    this.detailAddress = '',
  });

  factory Area.fromMap(Map<String, dynamic> data) {
    return Area(
      userId: data['uid'],
      prefecture: data['prefecture'],
      cities: data['cities'],
      address: data['address'],
      detailAddress: data['detailAddress'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'prefecture': prefecture,
      'cities': cities,
      'address': address,
      'detailAddress': detailAddress,
    };
  }
}
