import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class IFirebaseService {
  // Getters
  FirebaseFirestore get firestore;
  FirebaseAuth get auth;
  FirebaseStorage get storage;

  // User related methods
  Future<User?> getCurrentUser();
  Future<String?> getUserRole();

  // Storage related methods
  Future<String> uploadFile(String path, Uint8List bytes);
  Future<void> deleteFile(String url);

  // Firestore related methods
  Future<void> addDocument(String collection, Map<String, dynamic> data);
  Future<void> updateDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  );
  Future<void> deleteDocument(String collection, String docId);
  Stream<QuerySnapshot> getCollectionStream(String collection);
}
