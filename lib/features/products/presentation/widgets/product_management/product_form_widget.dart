
import 'package:final_tasks_front_end/features/products/presentation/cubit/product_management_cubit.dart';
import 'package:final_tasks_front_end/features/products/presentation/cubit/product_management_state.dart';
import 'package:final_tasks_front_end/features/products/presentation/widgets/product_management/custom_text_field.dart';
import 'package:final_tasks_front_end/features/products/presentation/widgets/product_management/image_picker_widget.dart';
import 'package:final_tasks_front_end/features/products/presentation/widgets/product_management/save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';

class ProductFormWidget extends StatefulWidget {
  const ProductFormWidget({super.key});

  @override
  State<ProductFormWidget> createState() => _ProductFormWidgetState();
}

class _ProductFormWidgetState extends State<ProductFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? selectedMainType;
  String? selectedSubType;

  final List<String> mainTypes = ['Makeup', 'Skincare', 'Fragrance'];

  final Map<String, List<String>> subTypesMap = {
    'Makeup': ['Lipstick', 'Foundation', 'Blush', 'Mascara'],
    'Skincare': ['Moisturizer', 'Cleanser', 'Toner'],
    'Fragrance': ['Perfume', 'Body Spray'],
  };

  InputDecoration _buildDropdownDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.primary),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      filled: true,
      fillColor: AppColors.background,
    );
  }

  Future<void> addProduct() async {
    final cubit = context.read<ProductManagementCubit>();

    if (_formKey.currentState!.validate()) {
      try {
        String? imageUrl;

        if (cubit.state is ProductImagePicked) {
          final imageFile = (cubit.state as ProductImagePicked).image;
          final fileName = DateTime.now().millisecondsSinceEpoch.toString();
          final storageRef = FirebaseStorage.instance.ref().child(
            'product_images/$fileName.jpg',
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Uploading image...'),
              duration: Duration(seconds: 2),
            ),
          );

          try {
            final bytes = await imageFile.readAsBytes();
            await storageRef.putData(bytes);
            imageUrl = await storageRef.getDownloadURL();
          } catch (e, s) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Image upload failed: $e'),
                backgroundColor: Colors.red,
              ),
            );
            print('❌ Stack trace: $s');
            return;
          }
        }

        final productData = {
          'name': _nameController.text.trim(),
          'brand': _brandController.text.trim(),
          'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
          'description': _descriptionController.text.trim(),
          'image': imageUrl ?? '',
          'mainType': selectedMainType ?? '',
          'subType': selectedSubType ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance
            .collection('products')
            .add(productData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        cubit.clearFields();
        _nameController.clear();
        _brandController.clear();
        _priceController.clear();
        _descriptionController.clear();
        setState(() {
          selectedMainType = null;
          selectedSubType = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add product: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              CustomTextField(
                controller: _nameController,
                hintText: "Product Name",
                icon: Icons.label,
                validatorMessage: 'Please enter the product name',
              ),
              CustomTextField(
                controller: _brandController,
                hintText: "Brand",
                icon: Icons.business,
                validatorMessage: 'Please enter the brand',
              ),
              CustomTextField(
                controller: _priceController,
                hintText: "Price",
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validatorMessage: 'Please enter the price',
              ),
              CustomTextField(
                controller: _descriptionController,
                hintText: "Description",
                icon: Icons.description,
                validatorMessage: 'Please enter the description',
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedMainType,
                style: const TextStyle(color: AppColors.primary),
                decoration: _buildDropdownDecoration("Main Type"),
                items:
                    mainTypes
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              type,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMainType = value;
                    selectedSubType = null;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedSubType,
                style: const TextStyle(color: AppColors.primary),
                decoration: _buildDropdownDecoration("Sub Type"),
                items:
                    (selectedMainType != null
                            ? subTypesMap[selectedMainType] ?? []
                            : [])
                        .map<DropdownMenuItem<String>>(
                          (sub) => DropdownMenuItem<String>(
                            value: sub,
                            child: Text(
                              sub,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSubType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<ProductManagementCubit, ProductManagementState>(
                builder: (context, state) {
                  return ImagePickerWidget(
                    image: state is ProductImagePicked ? state.image : null,
                    onTap:
                        () =>
                            context.read<ProductManagementCubit>().pickImage(),
                  );
                },
              ),
              const SizedBox(height: 40),
              SaveButton(onPressed: addProduct, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
