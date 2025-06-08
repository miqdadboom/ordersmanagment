


import '../models/EmployeeModel.dart';

abstract class EmployeeRepository {
  Future<void> addEmployee(EmployeeModel employee, String password);
  Future<EmployeeModel?> getEmployeeById(String userId);
  Future<void> updateEmployee(EmployeeModel employee);
  Future<void> deleteEmployee(String userId);

}
