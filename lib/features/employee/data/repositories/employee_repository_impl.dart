import '../../data/datasources/firebase_employee_service.dart';
import '../models/EmployeeModel.dart';
import 'employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final FirebaseEmployeeService firebaseService;

  EmployeeRepositoryImpl(this.firebaseService);

  @override
  Future<void> addEmployee(EmployeeModel employee, String password) {
    return firebaseService.addEmployee(employee, password);
  }

  @override
  Future<EmployeeModel?> getEmployeeById(String userId) {
    return firebaseService.getEmployeeById(userId);
  }

  @override
  Future<void> updateEmployee(EmployeeModel employee) {
    return firebaseService.updateEmployee(employee);
  }

  @override
  Future<void> deleteEmployee(String userId) {
    return firebaseService.deleteEmployee(userId);
  }
}
