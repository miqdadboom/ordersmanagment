import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/mange_action_buttons.dart';
import '../widgets/mange_search_bar.dart';
import 'add_employee_screen.dart';
import 'edit_employee_screen.dart';

class ManageEmployee extends StatefulWidget {
  @override
  State<ManageEmployee> createState() => _ManageEmployeeState();
}

class _ManageEmployeeState extends State<ManageEmployee> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _sortEmployees(String value) {
    // Sorting logic can be implemented later if needed.
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data?.docs ?? [];

                  final filtered = docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = data['name']?.toLowerCase() ?? '';
                    final job = data['jobTitle']?.toLowerCase() ?? '';
                    return name.contains(_searchQuery) || job.contains(_searchQuery);
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text("No employees found"));
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final data = filtered[index].data() as Map<String, dynamic>;
                      final id = filtered[index].id;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(data['name'] ?? ''),
                          subtitle: Text(data['jobTitle'] ?? ''),
                          trailing: const Icon(Icons.edit, color: AppColors.primary),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditEmployee(userId: id),
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
