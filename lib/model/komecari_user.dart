
class KomecariUser {
  String _uid;
  String _profileImageUrl;
  String _userName;
  bool _isSeller = false;
  String _email;

  String get uid => this._uid;
  String get userName => this._userName;
  String get prifileImageUrl => this._profileImageUrl;
  bool get isSeller => this._isSeller;
  String get email => this._email;
  // TODO - Please add the product receiving address : String receivingAddress ,
  // TODO - Create an area class to Firestore to store the area uid in the receiving address.

  KomecariUser({
    String uid,
    String userName,
    bool isSeller,
    String email,
    String profileImageUrl,
  }) {
    _uid = uid ?? '';
    _userName = userName ?? '';
    _isSeller = isSeller ?? false;
    _email = email ?? '';
    _profileImageUrl = profileImageUrl;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'userName': userName,
      'profileImageUrl': prifileImageUrl,
      'isSeller': isSeller,
      'email': email,
    };
  }

  factory KomecariUser.fromMap(Map<String, dynamic> data) {
    return KomecariUser(
      uid: data['uid'],
      userName: data[('userName')],
      isSeller: data['isSeller'],
      email: data['email'],
      profileImageUrl: data['profileImageUrl'],
    );
  }
}
