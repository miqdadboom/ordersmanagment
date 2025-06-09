import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IBaseRepository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<void> add(T item);
  Future<void> update(String id, T item);
  Future<void> delete(String id);
  Stream<QuerySnapshot> getStream();
}
