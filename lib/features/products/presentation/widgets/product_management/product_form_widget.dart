import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordersmanagment_app/features/products/presentation/cubit/product_management_cubit.dart';
import 'package:ordersmanagment_app/features/products/presentation/widgets/product_management/custom_text_field.dart';
import 'package:ordersmanagment_app/features/products/presentation/widgets/product_management/image_picker_widget.dart';
import 'package:ordersmanagment_app/features/products/presentation/widgets/product_management/save_button.dart';

class ProductFormWidget extends StatelessWidget {
  const ProductFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _brandController = TextEditingController();
    final _priceController = TextEditingController();
    final _descriptionController = TextEditingController();

    void _submitForm() {
      if (_formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.read<ProductManagementCubit>().clearFields();
        _nameController.clear();
        _brandController.clear();
        _priceController.clear();
        _descriptionController.clear();
      }
    }

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
              SaveButton(onPressed: _submitForm),
            ],
          ),
        ),
      ),
    );
  }
}
