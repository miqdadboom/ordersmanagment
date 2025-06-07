import 'dart:io';
import 'package:final_tasks_front_end/features/products/presentation/cubit/product_management_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/firebase/product_repository.dart';

class ProductManagementCubit extends Cubit<ProductManagementState> {
  final ProductRepository repository;

  ProductManagementCubit(this.repository) : super(ProductInitial());

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        emit(ProductImagePicked(File(pickedFile.path)));
      }
    } catch (e) {
      emit(ProductError("Failed to pick image: $e"));
    }
  }

  void clearFields() {
    emit(ProductInitial());
  }

  Future<void> addProduct(Map<String, dynamic> product) async {
    await repository.addProduct(product);
  }

  Future<void> updateProduct(
    String documentId,
    Map<String, dynamic> product,
  ) async {
    await repository.updateProduct(documentId, product);
  }

  Future<void> deleteProduct(String documentId) async {
    await repository.deleteProduct(documentId);
  }
}
