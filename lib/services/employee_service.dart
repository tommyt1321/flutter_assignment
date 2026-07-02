import '../data/mock_hr_data.dart';
import '../models/employee.dart';

class EmployeeService {
  static final EmployeeService _instance =
      EmployeeService._internal();

  factory EmployeeService() => _instance;

  EmployeeService._internal();

  final List<Employee> _employees =
      mockEmployees.map(Employee.fromJson).toList();

  List<Employee> getEmployees() => _employees;

  Employee? getEmployeeById(String id) {
    try {
      return _employees.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Employee> searchEmployees(String query) {
    if (query.isEmpty) return getEmployees();

    return _employees.where((employee) {
      return employee.fullName
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();
  }

  void deductLeaveBalance(String employeeId, int days) {
    final employee = getEmployeeById(employeeId);

    if (employee == null) {
      throw Exception('Employee not found.');
    }

    employee.leaveBalance -= days;
  }
}