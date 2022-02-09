
class User {
  String guid;
  String? phoneNumber;
  String? username;
  String? photoUrl;

  User({required this.guid, this.phoneNumber, this.username, this.photoUrl});


  factory User.fromMap(Map data) {
    return User(
        guid: data['uid'],
        phoneNumber: data['phoneNumber'],
        username: data['username'],
        photoUrl: data['photoUrl']);
  }
  @override
  String toString() {
    return '{ documentId: $guid, phoneNumb: $phoneNumber, username: $username, photoUrl: $photoUrl }';
  }
}
