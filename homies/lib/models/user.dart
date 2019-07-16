class User {
  final String email;
  String displayName;
  List<String> groups;
  //String profilePicPath;

  User({this.email, this.displayName, this.groups, /*this.profilePicPath*/});

  User.fromJson(Map<String, dynamic> data)
    : email = data['email'],
      displayName = data['display_name'],
      groups = new List<String>.from(data['groups'].cast<String>());
      //profilePicPath = data['pic_path'];
}