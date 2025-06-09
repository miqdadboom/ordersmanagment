import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_category_dialog.dart';
import '../../../../../../features/homepage/presentation/widgets/promo_banner_management/confirm_delete_dialog.dart';
import '../../../../../../features/homepage/data/firebase/category_repository.dart';
import '../../../../../../features/homepage/domain/entities/category.dart';

class CategoryCard extends StatelessWidget {
  final String docId;
  final String name;
  final String imageUrl;
  final List<String> subtypes;

  const CategoryCard({
    super.key,
    required this.docId,
    required this.name,
    required this.imageUrl,
    required this.subtypes,
  });

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showConfirmDeleteDialog(context);
    if (confirmed == true) {
      await CategoryRepository().deleteCategory(docId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _edit(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => EditCategoryDialog(
            docId: docId,
            name: name,
            imageUrl: imageUrl,
            subtypes: subtypes,
            onUpdated: () {
              // يمكن تحديث القائمة أو إعادة تحميلها هنا إذا لزم
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child:
                imageUrl.isNotEmpty
                    ? Image.network(
                      imageUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    )
                    : Container(
                      width: 48,
                      height: 48,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image,
                        color: Colors.grey,
                        size: 28,
                      ),
                    ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtypes.join(', '),
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () => _edit(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _delete(context),
          ),
        ],
      ),
    );
  }
}
