import '../data/mock_hr_data.dart';
import '../models/employee.dart';

class EmployeeService {
  static final EmployeeService _instance = EmployeeService._internal();

  factory EmployeeService() => _instance;

  EmployeeService._internal();

  final List<Employee> _employees = mockEmployees
      .map(Employee.fromJson)
      .toList();

  List<Employee> getEmployees() => _employees;

  Employee? getEmployeeById(String id) {
    try {
      return _employees.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Employee> searchEmployees(String query) {
    // Remove spaces and convert to lowercase for the search query
    final normalizedQuery = query.replaceAll(' ', '').toLowerCase();

    if (normalizedQuery.isEmpty) return getEmployees();

    return _employees.where((employee) {
      // Remove spaces and convert to lowercase for the employee data
      final normalizedName = employee.fullName
          .replaceAll(' ', '')
          .toLowerCase();
      final normalizedDept = employee.department
          .replaceAll(' ', '')
          .toLowerCase();
      final normalizedPos = employee.position.replaceAll(' ', '').toLowerCase();

      return normalizedName.contains(normalizedQuery) ||
          normalizedDept.contains(normalizedQuery) ||
          normalizedPos.contains(normalizedQuery);
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
