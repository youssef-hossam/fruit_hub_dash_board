import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_hub_dash_board/core/services/database_service.dart';

class FirebaseFirestoreService implements DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    await firestore.collection(path).doc(documentId).set(data);
  }

  @override
  Future<void> updateData({
    required String path,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await firestore.collection(path).doc(documentId).update(data);
  }

  @override
  Future<void> deleteData({
    required String path,
    required String documentId,
  }) async {
    await firestore.collection(path).doc(documentId).delete();
  }

  @override
  Future<List<Map<String, dynamic>>> getCollection({
    required String path,
  }) async {
    final snapshot = await firestore.collection(path).get();
    return snapshot.docs
        .map((doc) => {...doc.data(), 'id': doc.data()['id'] ?? doc.id})
        .toList();
  }
}
