import 'package:cloud_firestore/cloud_firestore.dart';
import '../interfaces/ibase_repository.dart';
import '../firebase/firebase_service.dart';

abstract class BaseRepository<T> implements IBaseRepository<T> {
  final FirebaseService _firebaseService;
  final String collection;

  BaseRepository(this._firebaseService, this.collection);

  T fromMap(Map<String, dynamic> map, String id);
  Map<String, dynamic> toMap(T item);

  @override
  Future<List<T>> getAll() async {
    final snapshot =
        await _firebaseService.firestore.collection(collection).get();
    return snapshot.docs.map((doc) => fromMap(doc.data(), doc.id)).toList();
  }

  @override
  Future<T?> getById(String id) async {
    final doc =
        await _firebaseService.firestore.collection(collection).doc(id).get();
    if (!doc.exists) return null;
    return fromMap(doc.data()!, doc.id);
  }

  @override
  Future<void> add(T item) async {
    await _firebaseService.addDocument(collection, toMap(item));
  }

  @override
  Future<void> update(String id, T item) async {
    await _firebaseService.updateDocument(collection, id, toMap(item));
  }

  @override
  Future<void> delete(String id) async {
    await _firebaseService.deleteDocument(collection, id);
  }

  @override
  Stream<QuerySnapshot> getStream() {
    return _firebaseService.getCollectionStream(collection);
  }
}
