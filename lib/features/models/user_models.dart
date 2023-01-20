import 'dart:convert';

class UserModel {
  final String type;
  final String email;
  final String userName;
  final String name;
  final String uid;
  final String profilePic;
  final String bgPic;
  final String phoneNumber;
  final bool isOnline;
  final List<String> groupID;
  final String lastOnline;
  UserModel({
    required this.type,
    required this.email,
    required this.userName,
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.bgPic,
    required this.phoneNumber,
    required this.isOnline,
    required this.groupID,
    required this.lastOnline,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'type': type});
    result.addAll({'email': email});
    result.addAll({'userName': userName});
    result.addAll({'name': name});
    result.addAll({'uid': uid});
    result.addAll({'profilePic': profilePic});
    result.addAll({'bgPic': bgPic});
    result.addAll({'phoneNumber': phoneNumber});
    result.addAll({'isOnline': isOnline});
    result.addAll({'groupID': groupID});
    result.addAll({'lastOnline': lastOnline});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      bgPic: map['bgPic'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      isOnline: map['isOnline'] ?? false,
      groupID: List<String>.from(map['groupID']),
      lastOnline: map['lastOnline'] ?? '',
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      type: map['type'] ?? '',
    );
  }
}

class try1 {
  final String lastOnline;
  try1({
    required this.lastOnline,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'lastOnline': lastOnline});

    return result;
  }

  factory try1.fromMap(Map<String, dynamic> map) {
    return try1(
      lastOnline: map['lastOnline'],
    );
  }
}
