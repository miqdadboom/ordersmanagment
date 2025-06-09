import 'dart:io';
import 'package:final_tasks_front_end/core/constants/app_size_box.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/widgets/product_management/image_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../features/homepage/data/firebase/category_repository.dart';
import '../../../../../../features/homepage/domain/entities/category.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({super.key});

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _subtypeController = TextEditingController();
  final _customTypeController = TextEditingController();
  final _typeSearchController = TextEditingController();

  String? _selectedType;
  File? _imageFile;
  List<String> _subtypes = [];
  List<String> _types = ['Makeup', 'Skincare', 'Fragrance', 'Other'];
  List<String> _filteredTypes = [];
  bool _isLoading = false;

  final _categoryRepository = CategoryRepository();

  @override
  void initState() {
    super.initState();
    _loadTypes();
    _filteredTypes = List.from(_types);
    _typeSearchController.addListener(_filterTypes);
  }

  void _filterTypes() {
    final query = _typeSearchController.text.toLowerCase();
    setState(() {
      _filteredTypes =
          _types.where((t) => t.toLowerCase().contains(query)).toList();
    });
  }

  Future<void> _loadTypes() async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('categories').get();
      final firestoreTypes =
      snapshot.docs
          .map((doc) => doc.data()['name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toSet();

      setState(() {
        _types = [
          ...{'Makeup', 'Skincare', 'Fragrance', ...firestoreTypes},
        ];
        _filteredTypes = List.from(_types);
      });
    } catch (_) {}
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category type'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final existing = await _categoryRepository.getCategories();
      final newCategoryName = _selectedType?.trim() ?? '';
      final isDuplicate = existing.any(
            (cat) => cat.name.toLowerCase() == newCategoryName.toLowerCase(),
      );
      if (isDuplicate) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('هذا النوع موجود بالفعل'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
        return;
      }
      if (existing.length >= 8) {
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
              children: const [
                Text(
                  'You can only have 8 categories.',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'Please delete at least one category to add a new one.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
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
        return;
      }

      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance.ref().child(
        'category_images/$fileName.jpg',
      );
      final bytes = await _imageFile!.readAsBytes();
      await storageRef.putData(bytes);
      final imageUrl = await storageRef.getDownloadURL();

      final categoryName =
      _selectedType == 'Other'
          ? _customTypeController.text.trim()
          : _selectedType!;

      final category = Category(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: newCategoryName,
        imageUrl: imageUrl,
        subtypes: _subtypes,
      );

      await _categoryRepository.addCategory(category);
      _resetForm();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding category: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _resetForm() {
    setState(() {
      _selectedType = null;
      _imageFile = null;
      _subtypes.clear();
      _subtypeController.clear();
      _customTypeController.clear();
      _typeSearchController.clear();
    });
  }

  @override
  void dispose() {
    _subtypeController.dispose();
    _customTypeController.dispose();
    _typeSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue value) {
              return _filteredTypes.where(
                    (type) => type.toLowerCase().contains(value.text.toLowerCase()),
              );
            },
            onSelected: (value) {
              setState(() {
                _selectedType = value;
              });
            },
            fieldViewBuilder: (context, controller, focusNode, _) {
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                decoration: const InputDecoration(labelText: 'Category Type'),
                validator:
                    (value) =>
                value == null || value.isEmpty
                    ? 'Please select a type'
                    : null,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
              );
            },
          ),
          if (_selectedType == 'Other') ...[
            AppSizedBox.height(context, 0.015),
            TextFormField(
              controller: _customTypeController,
              decoration: const InputDecoration(labelText: 'Custom Type'),
              validator:
                  (value) =>
              value == null || value.isEmpty
                  ? 'Enter a custom type'
                  : null,
            ),
          ],
          AppSizedBox.height(context, 0.02),
          ImagePickerWidget(image: _imageFile, onTap: _pickImage),
          AppSizedBox.height(context, 0.02),
          TextFormField(
            controller: _subtypeController,
            decoration: InputDecoration(
              labelText: 'Add Subtype',
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (_subtypeController.text.isNotEmpty) {
                    if (_subtypes.length >= 10) {
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
                              const Text(
                                'You can only have 10 subtypes.',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              AppSizedBox.height(context, 0.015),
                              const Text(
                                'Please delete at least one subtype to add a new one.',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              AppSizedBox.height(context, 0.01),
                              const Text.rich(
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
                      return;
                    }
                    setState(() {
                      _subtypes.add(_subtypeController.text.trim());
                      _subtypeController.clear();
                    });
                  }
                },
              ),
            ),
          ),
          if (_subtypes.isNotEmpty)
            Wrap(
              spacing: 8,
              children:
              _subtypes
                  .map(
                    (e) => Chip(
                  label: Text(e),
                  onDeleted:
                      () => setState(() {
                    _subtypes.remove(e);
                  }),
                ),
              )
                  .toList(),
            ),
          AppSizedBox.height(context, 0.025),
          ElevatedButton(
            onPressed: _isLoading ? null : _saveCategory,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF43A393),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Save Category'),
                if (_isLoading) ...[
                  AppSizedBox.width(context, 0.03),
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}