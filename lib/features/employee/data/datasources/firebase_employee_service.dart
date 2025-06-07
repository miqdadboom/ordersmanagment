import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/EmployeeModel.dart';

class FirebaseEmployeeService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _collection = FirebaseFirestore.instance.collection('users');

  // إضافة موظف
  Future<void> addEmployee(EmployeeModel employee, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: employee.email,
      password: password,
    );

    await _collection.doc(credential.user!.uid).set(employee.toMap());
  }

  // استرجاع موظف
  Future<EmployeeModel?> getEmployeeById(String userId) async {
    final doc = await _collection.doc(userId).get();
    if (!doc.exists) return null;
    return EmployeeModel.fromFirestore(doc.id, doc.data()!);
  }

  // تعديل موظف
  Future<void> updateEmployee(EmployeeModel employee) async {
    await _collection.doc(employee.id).update(employee.toMap());
  }

  // حذف موظف
  Future<void> deleteEmployee(String userId) async {
    await _collection.doc(userId).delete();
  }

  Stream<List<EmployeeModel>> getAllEmployeesStream() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return EmployeeModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
