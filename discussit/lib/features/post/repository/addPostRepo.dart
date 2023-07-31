import 'package:cloud_firestore/cloud_firestore.dart';

class AddPostRepository {
  final FirebaseFirestore _firestore;
  AddPostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
}
