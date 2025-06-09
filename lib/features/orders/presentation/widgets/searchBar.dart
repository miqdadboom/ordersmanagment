import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../cubit/orders_cubit.dart';

Widget buildSearchBar(
  BuildContext context, {
  required void Function(String) onSearch,
  required void Function(String) onFilter,
  required String selectedStatus,
}) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border, width: 1.5),
            ),
            child: TextField(
              onChanged: onSearch,
              decoration: const InputDecoration(
                hintText: 'Search orders...',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: InputBorder.none,
                hintStyle: TextStyle(color: AppColors.textDark, fontSize: 16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Filter by Status'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Row(
                              children: [
                                const Text('All'),
                                if (selectedStatus == '')
                                  const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                              ],
                            ),
                            onTap: () {
                              onFilter('');
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Row(
                              children: [
                                const Text('Passed'),
                                if (selectedStatus == 'Passed')
                                  const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                              ],
                            ),
                            onTap: () {
                              onFilter('Passed');
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Row(
                              children: [
                                const Text('Failed'),
                                if (selectedStatus == 'Failed')
                                  const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                              ],
                            ),
                            onTap: () {
                              onFilter('Failed');
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Row(
                              children: [
                                const Text('Prepared'),
                                if (selectedStatus == 'Prepared')
                                  const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                              ],
                            ),
                            onTap: () {
                              onFilter('Prepared');
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Row(
                              children: [
                                const Text('Not Prepared'),
                                if (selectedStatus == 'Not Prepared')
                                  const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                              ],
                            ),
                            onTap: () {
                              onFilter('Not Prepared');
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
              );
            },
            child: const Icon(Icons.filter_list),
          ),
        ),
      ],
    ),
  );
}
