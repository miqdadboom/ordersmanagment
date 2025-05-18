import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/mange_action_buttons.dart';
import '../widgets/mange_employee_list.dart';
import '../widgets/mange_search_bar.dart';
import 'add_employee_screen.dart';

class ManageEmployee extends StatefulWidget {
  @override
  State<ManageEmployee> createState() => _ManageEmployeeState();
}

class _ManageEmployeeState extends State<ManageEmployee> {
  TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _originalEmployees = [
    {"name": "Salah Nofal", "job": "WORK"},
    {"name": "Ahmed Istatieh", "job": "DEVELOPER"},
    {"name": "Miqdad Boom", "job": "HR MANAGER"},
    {"name": "Maya Qasim", "job": "ACCOUNTANT"},
    {"name": "Fton Ali", "job": "DESIGNER"},
    {"name": "HANA Omar", "job": "MARKETING"},
    {"name": "HANA Omar", "job": "MARKETING"},
    {"name": "HANA Omar", "job": "MARKETING"},
    {"name": "HANA Omar", "job": "MARKETING"},
    {"name": "HANA Omar", "job": "MARKETING"},
  ];

  List<Map<String, String>> employees = [];

  @override
  void initState() {
    super.initState();
    employees = List.from(_originalEmployees);
  }

  void _filterEmployees(String query) {
    setState(() {
      employees = _originalEmployees
          .where((employee) =>
      employee["name"]!.toLowerCase().contains(query.toLowerCase()) ||
          employee["job"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _sortEmployees(String value) {
    setState(() {
      switch (value) {
        case 'name_asc':
          employees.sort((a, b) => a['name']!.compareTo(b['name']!));
          break;
        case 'name_desc':
          employees.sort((a, b) => b['name']!.compareTo(a['name']!));
          break;
        case 'job_asc':
          employees.sort((a, b) => a['job']!.compareTo(b['job']!));
          break;
        case 'job_desc':
          employees.sort((a, b) => b['job']!.compareTo(a['job']!));
          break;
        case 'reset':
          employees = List.from(_originalEmployees);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        title: const Text("Company Employee"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SearchBarWidget(
              controller: _searchController,
              onChanged: _filterEmployees,
            ),
            const SizedBox(height: 10),
            ActionButtonsWidget(
              onAddPressed: () {
                Navigator.pushNamed(context, '/add');

              },
              onSortSelected: _sortEmployees,
            ),
            const SizedBox(height: 15),
            Expanded(child: EmployeeListWidget(employees: employees)),
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
