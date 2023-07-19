// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String name;
  final String email;
  final String profilepic;
  final String banner;
  final String uid;
  final String bio;
  final bool isAuthenticated; //guest or not
  final int karma;
  UserModel({
    required this.name,
    required this.email,
    required this.profilepic,
    required this.banner,
    required this.uid,
    required this.bio,
    required this.isAuthenticated,
    required this.karma,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? profilepic,
    String? banner,
    String? uid,
    String? bio,
    bool? isAuthenticated,
    int? karma,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      profilepic: profilepic ?? this.profilepic,
      banner: banner ?? this.banner,
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      karma: karma ?? this.karma,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'profilepic': profilepic,
      'banner': banner,
      'uid': uid,
      'bio': bio,
      'isAuthenticated': isAuthenticated,
      'karma': karma,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'] as String,
        email: map['email'] as String,
        profilepic: map['profilepic'] as String,
        banner: map['banner'] as String,
        uid: map['uid'] as String,
        bio: map['bio'] as String,
        isAuthenticated: map['isAuthenticated'] as bool,
        karma: map['karma'] as int);
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, profilepic: $profilepic, banner: $banner, uid: $uid, bio: $bio, isAuthenticated: $isAuthenticated, karma: $karma)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.profilepic == profilepic &&
        other.banner == banner &&
        other.uid == uid &&
        other.bio == bio &&
        other.isAuthenticated == isAuthenticated &&
        other.karma == karma;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        profilepic.hashCode ^
        banner.hashCode ^
        uid.hashCode ^
        bio.hashCode ^
        isAuthenticated.hashCode ^
        karma.hashCode;
  }
}
