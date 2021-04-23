

class KomecariUser{
  String _uid = '';
  String? _profileImageUrl;
  String _userName = '';
  bool _isSeller = false;
  String _email = '';
  bool _hasShippingArea = false;

  String get uid => this._uid;
  String get userName => this._userName;
  bool get hasShippingArea => this._hasShippingArea;
  String? get prifileImageUrl => this._profileImageUrl;
  bool get isSeller => this._isSeller;
  String get email => this._email;

  KomecariUser({
    String? uid,
    String? userName,
    bool? isSeller,
    String? email,
    String? profileImageUrl,
    bool? hasShippingArea,
  }) {
    _uid = uid ?? '';
    _userName = userName ?? '';
    _isSeller = isSeller ?? false;
    _email = email ?? '';
    _profileImageUrl = profileImageUrl;
    _hasShippingArea = hasShippingArea ?? false;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'userName': userName,
      'profileImageUrl': prifileImageUrl,
      'isSeller': isSeller,
      'email': email,
      'hasShippingArea' : hasShippingArea,
    };
  }

  factory KomecariUser.fromMap(Map<String, dynamic> data) {
    return KomecariUser(
      uid: data['uid'],
      userName: data[('userName')],
      isSeller: data['isSeller'],
      email: data['email'],
      profileImageUrl: data['profileImageUrl'],
      hasShippingArea: data['hasShippingArea'],
    );
  }
  void updateWith({
    bool? isSeller,
    String? email,
    String? profileImageUrl,
    bool? hasShippingArea,
  }) {
    _isSeller = isSeller ?? this.isSeller;
    _email = email ?? this.email;
    _profileImageUrl = profileImageUrl ?? this.prifileImageUrl;
    _hasShippingArea = hasShippingArea ?? this.hasShippingArea;
  }
}
