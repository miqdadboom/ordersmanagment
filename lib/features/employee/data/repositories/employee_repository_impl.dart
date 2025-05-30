import '../../data/datasources/firebase_employee_service.dart';
import '../models/EmployeeModel.dart';
import 'employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final FirebaseEmployeeService _firebaseService;

  EmployeeRepositoryImpl(this._firebaseService);

  FirebaseEmployeeService get firebaseService => _firebaseService;

  @override
  Future<void> addEmployee(EmployeeModel employee, String password) {
    return _firebaseService.addEmployee(employee, password);
  }

  @override
  Future<EmployeeModel?> getEmployeeById(String userId) {
    return _firebaseService.getEmployeeById(userId);
  }

  @override
  Future<void> updateEmployee(EmployeeModel employee) {
    return _firebaseService.updateEmployee(employee);
  }

  @override
  Future<void> deleteEmployee(String userId) {
    return _firebaseService.deleteEmployee(userId);
  }
}
