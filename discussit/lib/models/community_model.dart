// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Community {
  final String id;
  final String name;
  final String banner;
  final String avatar;
  final List<String> members;
  final List<String> moderators;

  final String createdBy;
  final DateTime createdAt;
  final String description;
  final List<String> posts;
  Community({
    required this.id,
    required this.name,
    required this.banner,
    required this.avatar,
    required this.members,
    required this.moderators,
    required this.createdBy,
    required this.createdAt,
    required this.description,
    required this.posts,
  });

  Community copyWith({
    String? id,
    String? name,
    String? banner,
    String? avatar,
    List<String>? members,
    List<String>? moderators,
    String? createdBy,
    DateTime? createdAt,
    String? description,
    List<String>? posts,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      banner: banner ?? this.banner,
      avatar: avatar ?? this.avatar,
      members: members ?? this.members,
      moderators: moderators ?? this.moderators,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      posts: posts ?? this.posts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'banner': banner,
      'avatar': avatar,
      'members': members,
      'moderators': moderators,
      'createdBy': createdBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'description': description,
      'posts': posts,
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id'] as String,
      name: map['name'] as String,
      banner: map['banner'] as String,
      avatar: map['avatar'] as String,
      members: List<String>.from(map['members'] as List<String>),
      moderators: List<String>.from(
          map['moderators'] as List<String>), // Added .from here
      createdBy: map['createdBy'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      description: map['description'] as String,
      posts: List<String>.from(map['posts'] as List<String>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Community.fromJson(String source) =>
      Community.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Community(id: $id, name: $name, banner: $banner, avatar: $avatar, members: $members, moderators: $moderators, createdBy: $createdBy, createdAt: $createdAt, description: $description, posts: $posts)';
  }

  @override
  bool operator ==(covariant Community other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.banner == banner &&
        other.avatar == avatar &&
        listEquals(other.members, members) &&
        listEquals(other.moderators, moderators) &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.description == description &&
        listEquals(other.posts, posts);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        banner.hashCode ^
        avatar.hashCode ^
        members.hashCode ^
        moderators.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        description.hashCode ^
        posts.hashCode;
  }
}
