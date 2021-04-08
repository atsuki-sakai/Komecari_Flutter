class Area {
  String userId = '';
  String prefecture = '';
  String city = '';
  String town = '';
  String address = '';

  Area({
    this.userId = '',
    this.prefecture = '',
    this.city = '',
    this.town = '',
    this.address = '',
  });

  factory Area.fromMap(Map<String, dynamic> data) {
    return Area(
      prefecture: data['prefecture'],
      city: data['city'],
      town: data['town'],
      address: data['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'prefecture': prefecture,
      'city': city,
      'town': town,
      'address': address,
    };
  }
}
