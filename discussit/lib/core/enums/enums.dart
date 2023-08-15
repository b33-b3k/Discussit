enum ThemeMode {
  light,
  dark,
}

enum UserKarma { comment, textPost, imagePost, linkPost, deletePost }

extension UserKarmaExtension on UserKarma {
  int get karma {
    return switch (this) {
      UserKarma.comment => 1,
      UserKarma.textPost => 2,
      UserKarma.imagePost => 3,
      UserKarma.linkPost => 3,
      UserKarma.deletePost => -1,
    };
  }
}
