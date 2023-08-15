// ignore_for_file: public_member_api_docs, sort_constructors_first

class Comments {
  final String id;
  final String text;
  final String postId;
  final DateTime createdAt;
  final String username;
  final String profilePic;
  Comments({
    required this.id,
    required this.text,
    required this.postId,
    required this.createdAt,
    required this.username,
    required this.profilePic,
  });

  Comments copyWith({
    String? id,
    String? text,
    String? postId,
    DateTime? createdAt,
    String? username,
    String? profilePic,
  }) {
    return Comments(
      id: id ?? this.id,
      text: text ?? this.text,
      postId: postId ?? this.postId,
      createdAt: createdAt ?? this.createdAt,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'postId': postId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'username': username,
      'profilePic': profilePic,
    };
  }

  factory Comments.fromMap(Map<String, dynamic> map) {
    return Comments(
      id: map['id'] as String,
      text: map['text'] as String,
      postId: map['postId'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      username: map['username'] as String,
      profilePic: map['profilePic'] as String,
    );
  }

  @override
  String toString() {
    return 'Comments(id: $id, text: $text, postId: $postId, createdAt: $createdAt, username: $username, profilePic: $profilePic)';
  }

  @override
  bool operator ==(covariant Comments other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.text == text &&
        other.postId == postId &&
        other.createdAt == createdAt &&
        other.username == username &&
        other.profilePic == profilePic;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        postId.hashCode ^
        createdAt.hashCode ^
        username.hashCode ^
        profilePic.hashCode;
  }
}
