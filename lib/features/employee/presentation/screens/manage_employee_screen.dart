import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/core/utils/user_access_control.dart';
import '../../../../core/user_role_access.dart';
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
    // Add sorting logic here if needed
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
      return const Scaffold(
        body: Center(child: Text('You are not authorized to view this page.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        title: Text(
          "Company Employee",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
          ),
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

                  final employees = snapshot.data ?? [];

                  final filtered = employees.where((employee) {
                    final name = employee.name.toLowerCase();
                    final job = employee.role.toLowerCase();
                    return name.contains(_searchQuery) || job.contains(_searchQuery);
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text("No employees found"));
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final employee = filtered[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(employee.name),
                          subtitle: Text(employee.role),
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
        child: SizedBox(height: 60, child: _buildBottomNavigationBar() ?? const SizedBox()),
      ),
    );
  }
}
