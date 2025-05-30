import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/core/utils/user_access_control.dart';
import '../../data/models/EmployeeModel.dart';
import '../../data/repositories/employee_repository_impl.dart';
import '../../data/datasources/firebase_employee_service.dart';
import '../widgets/mange_action_buttons.dart';
import '../widgets/mange_search_bar.dart';
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
  bool _sortAscending = true; // حالة السورت

  final _repo = EmployeeRepositoryImpl(FirebaseEmployeeService());

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final employee = await _repo.getEmployeeById(userId);
    if (!mounted) return;
    setState(() {
      _role = employee?.role;
      _loading = false;
    });
  }

  void _sortEmployees(String _) {
    setState(() {
      _sortAscending = !_sortAscending;
    });
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
        foregroundColor: AppColors.textLight,
        title: const Text("Company Employee"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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

                  // هنا تم تفعيل الفرز
                  filtered.sort((a, b) {
                    return _sortAscending
                        ? a.name.compareTo(b.name)
                        : b.name.compareTo(a.name);
                  });

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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.selectedItemNavigation,
        unselectedItemColor: AppColors.notSelectedItemNavigation,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Order'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Employee'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Product'),
        ],
        onTap: (index) {},
      ),
    );
  }
}
