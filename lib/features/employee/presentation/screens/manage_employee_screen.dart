import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/core/constants/app_text_styles.dart';
import 'package:final_tasks_front_end/core/utils/user_access_control.dart';
import '../../../../core/user_role_access.dart';
import '../../../../core/utils/app_exception.dart';
import '../../../../core/widgets/bottom_navigation_manager.dart';
import '../../data/models/EmployeeModel.dart';
import '../../data/repositories/employee_repository_impl.dart';
import '../../data/datasources/firebase_employee_service.dart';
import '../widgets/mange_action_buttons.dart';
import '../widgets/mange_search_bar.dart';
import 'add_employee_screen.dart';
import 'edit_employee_screen.dart';

class ManageEmployee extends StatefulWidget {
  const ManageEmployee({super.key});

  @override
  State<ManageEmployee> createState() => _ManageEmployeeState();
}

class _ManageEmployeeState extends State<ManageEmployee> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _role;
  bool _loading = true;
  String _sortBy = 'name';
  bool _ascending = true;

  final _repo = EmployeeRepositoryImpl(FirebaseEmployeeService());

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    final role = await UserRoleAccess.getUserRole();
    if (!mounted) return;
    setState(() {
      _role = role;
      _loading = false;
    });
  }

  void _sortEmployees(String value) {
    setState(() {
      if (_sortBy == value) {
        _ascending = !_ascending;
      } else {
        _sortBy = value;
        _ascending = true;
      }
    });
  }

  List<EmployeeModel> _applySearchAndSort(List<EmployeeModel> employees) {
    final filtered = employees.where((employee) {
      final name = employee.name.toLowerCase();
      final job = employee.role.toLowerCase();
      return name.contains(_searchQuery) || job.contains(_searchQuery);
    }).toList();

    filtered.sort((a, b) {
      final aValue = _sortBy == 'name' ? a.name : a.role;
      final bValue = _sortBy == 'name' ? b.name : b.role;
      return _ascending
          ? aValue.toLowerCase().compareTo(bValue.toLowerCase())
          : bValue.toLowerCase().compareTo(aValue.toLowerCase());
    });

    return filtered;
  }

  Widget? _buildBottomNavigationBar() {
    if (_role == 'admin') {
      return const BottomNavigationManager();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!UserAccessControl.ManageEmployee(_role!)) {
      return Scaffold(
        body: Center(
          child: Text(
            'You are not authorized to view this page.',
            style: AppTextStyles.bodySuggestion(context),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        title: Text(
          "Company Employee",
          style: AppTextStyles.headerConversation(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SearchBarWidget(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 10),
            ActionButtonsWidget(
              onAddPressed: () {
                Navigator.pushNamed(context, '/add');
              },
              onSortSelected: _sortEmployees,
            ),
            const SizedBox(height: 15),
            Expanded(
              child: StreamBuilder<List<EmployeeModel>>(
                stream: _repo.firebaseService.getAllEmployeesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    String message;
                    final error = snapshot.error;

                    if (error is FirebaseException &&
                        error.code == 'network-request-failed') {
                      message = NoInternetException().message;
                    } else if (error is FirebaseException) {
                      message = ServerException(error.message ?? "Firebase error").message;
                    } else if (error is AppException) {
                      message = error.message;
                    } else {
                      message = UnknownException(error.toString()).message;
                    }

                    return Center(
                      child: Text(
                        message,
                        style: AppTextStyles.bodySuggestion(context),
                      ),
                    );
                  }

                  final employees = snapshot.data ?? [];
                  final filtered = _applySearchAndSort(employees);

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        "No employees found",
                        style: AppTextStyles.bodySuggestion(context),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final employee = filtered[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(
                            employee.name,
                            style: AppTextStyles.bodySuggestion(context),
                          ),
                          subtitle: Text(
                            employee.role,
                            style: AppTextStyles.caption(context),
                          ),
                          trailing: const Icon(Icons.edit, color: AppColors.primary),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditEmployee(userId: employee.id!),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 60,
          child: _buildBottomNavigationBar() ?? const SizedBox(),
        ),
      ),
    );
  }
}