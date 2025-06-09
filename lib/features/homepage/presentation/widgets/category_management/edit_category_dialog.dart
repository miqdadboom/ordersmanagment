import 'dart:io';
import 'package:final_tasks_front_end/core/constants/app_size_box.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../features/homepage/data/firebase/category_repository.dart';
import '../../../../../../features/homepage/domain/entities/category.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditCategoryDialog extends StatefulWidget {
  final String docId;
  final String name;
  final String imageUrl;
  final List<String> subtypes;
  final VoidCallback? onUpdated;

  const EditCategoryDialog({
    super.key,
    required this.docId,
    required this.name,
    required this.imageUrl,
    required this.subtypes,
    this.onUpdated,
  });

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  late TextEditingController _nameController;
  late List<String> _subtypes;
  File? _newImageFile;
  bool _isLoading = false;
  final CategoryRepository _repository = CategoryRepository();
  final TextEditingController _subtypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _subtypes = List<String>.from(widget.subtypes);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveEdit() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a name.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      String imageUrl = widget.imageUrl;
      if (_newImageFile != null) {
        // رفع الصورة الجديدة إلى Firebase Storage
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final storageRef = FirebaseStorage.instance.ref().child(
          'category_images/$fileName.jpg',
        );
        final bytes = await _newImageFile!.readAsBytes();
        await storageRef.putData(bytes);
        imageUrl = await storageRef.getDownloadURL();
      }
      final updatedCategory = Category(
        id: widget.docId,
        name: _nameController.text.trim(),
        imageUrl: imageUrl,
        subtypes: _subtypes,
      );
      await _repository.updateCategory(widget.docId, updatedCategory);
      widget.onUpdated?.call();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update category: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Category', textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child:
                    _newImageFile != null
                        ? Image.file(
                          _newImageFile!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                        : (widget.imageUrl.isNotEmpty
                            ? Image.network(
                              widget.imageUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                            : Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.image,
                                color: Colors.grey,
                                size: 36,
                              ),
                            )),
              ),
            ),
            AppSizedBox.height(context, 0.02),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            AppSizedBox.height(context, 0.015),
            TextField(
              controller: _subtypeController,
              decoration: InputDecoration(
                labelText: 'Add Subtype',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_subtypeController.text.trim().isNotEmpty &&
                        _subtypes.length < 10) {
                      setState(() {
                        _subtypes.add(_subtypeController.text.trim());
                        _subtypeController.clear();
                      });
                    } else if (_subtypes.length >= 10) {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text(
                                'Limit Reached',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'You can only have 10 subtypes.',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  AppSizedBox.height(context, 0.015),
                                  Text(
                                    'Please delete at least one subtype to add a new one.',
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  AppSizedBox.height(context, 0.01),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Delete one',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' to continue.',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF39A28B),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                      );
                    }
                  },
                ),
              ),
            ),
            AppSizedBox.height(context, 0.01),
            if (_subtypes.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    _subtypes
                        .map(
                          (e) => Chip(
                            label: Text(e),
                            onDeleted: () {
                              setState(() {
                                _subtypes.remove(e);
                              });
                            },
                          ),
                        )
                        .toList(),
              ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: _isLoading ? null : _saveEdit,
          child:
              _isLoading
                  ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.2),
                  )
                  : const Text('Save'),
        ),
        OutlinedButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
