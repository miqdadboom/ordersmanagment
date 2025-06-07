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
  final Map<String, dynamic>? productData;

  const ProductFormWidget({super.key, this.productData});

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

  @override
  void initState() {
    super.initState();

    if (widget.productData != null) {
      _nameController.text = widget.productData!['name'] ?? '';
      _brandController.text = widget.productData!['brand'] ?? '';
      _priceController.text = widget.productData!['price'].toString();
      _descriptionController.text = widget.productData!['description'] ?? '';
      selectedMainType = widget.productData!['mainType'];
      selectedSubType = widget.productData!['subType'];
    }
  }

  InputDecoration _buildDropdownDecoration(
    String hintText,
    double screenWidth,
  ) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: AppColors.primary,
        fontSize: screenWidth * 0.04,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.03), // ~12
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      filled: true,
      fillColor: AppColors.background,
    );
  }

  Future<void> saveProduct() async {
    final cubit = context.read<ProductManagementCubit>();

    if (_formKey.currentState!.validate()) {
      try {
        String imageUrl = widget.productData?['image'] ?? '';

        if (cubit.state is ProductImagePicked) {
          final imageFile = (cubit.state as ProductImagePicked).image;
          final fileName = DateTime.now().millisecondsSinceEpoch.toString();
          final storageRef = FirebaseStorage.instance.ref().child(
            'product_images/$fileName.jpg',
          );

          final bytes = await imageFile.readAsBytes();
          await storageRef.putData(bytes);
          imageUrl = await storageRef.getDownloadURL();
        }

        final productData = {
          'name': _nameController.text.trim(),
          'brand': _brandController.text.trim(),
          'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
          'description': _descriptionController.text.trim(),
          'image': imageUrl,
          'mainType': selectedMainType ?? '',
          'subType': selectedSubType ?? '',
          'updatedAt': FieldValue.serverTimestamp(),
        };

        if (widget.productData != null) {
          await FirebaseFirestore.instance
              .collection('products')
              .doc(widget.productData!['documentId'])
              .update(productData);
        } else {
          await FirebaseFirestore.instance
              .collection('products')
              .add(productData);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.productData != null
                  ? 'Product updated successfully!'
                  : 'Product added successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        if (widget.productData == null) {
          cubit.clearFields();
          _nameController.clear();
          _brandController.clear();
          _priceController.clear();
          _descriptionController.clear();
          setState(() {
            selectedMainType = null;
            selectedSubType = null;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04, // ~16
        vertical: screenHeight * 0.005, // ~8
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.04), // ~30
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
              SizedBox(height: screenHeight * 0.01),
              DropdownButtonFormField<String>(
                value: selectedMainType,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: screenWidth * 0.04,
                ),
                decoration: _buildDropdownDecoration("Main Type", screenWidth),
                items:
                    mainTypes
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              type,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: screenWidth * 0.04,
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
              SizedBox(height: screenHeight * 0.02),
              DropdownButtonFormField<String>(
                value: selectedSubType,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: screenWidth * 0.04,
                ),
                decoration: _buildDropdownDecoration("Sub Type", screenWidth),
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
                                fontSize: screenWidth * 0.04,
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
              SizedBox(height: screenHeight * 0.02),
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
              SizedBox(height: screenHeight * 0.032), // ~40
              SaveButton(onPressed: saveProduct),
            ],
          ),
        ),
      ),
    );
  }
}
