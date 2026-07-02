import '../models/employee.dart';
import '../models/leave_request.dart';

class LeaveService {
  final List<LeaveRequest> _requests = [];

  List<LeaveRequest> get requests => List.unmodifiable(_requests);

  String submitLeave({
  required Employee employee,
  required LeaveRequest request,
}) {
  if (employee.id != request.employeeId) {
    throw Exception('Employee ID does not match leave request.');
  }

  if (request.endDate.isBefore(request.startDate)) {
    throw Exception('End date cannot be before start date.');
  }

  if (request.reason.trim().isEmpty) {
    throw Exception('Reason is required.');
  }

  if (request.totalDays > employee.leaveBalance) {
    throw Exception('Not enough leave balance.');
  }

  employee.leaveBalance -= request.totalDays;

final hasOverlap = _requests.any(
  (existing) =>
      existing.employeeId == request.employeeId &&
      request.startDate.isBefore(
        existing.endDate.add(const Duration(days: 1)),
      ) &&
      request.endDate.isAfter(
        existing.startDate.subtract(const Duration(days: 1)),
      ),
);

if (hasOverlap) {
  throw Exception('Leave dates overlap with an existing request.');
}
  _requests.add(request);

  return 'Leave application submitted successfully. Remaining balance: ${employee.leaveBalance} day(s).';
}
}
