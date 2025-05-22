import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProductManagementCubit extends Cubit<ProductManagementState> {
  final ImagePicker _picker = ImagePicker();

  ProductManagementCubit() : super(ProductManagementInitial());

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit(ProductImagePicked(File(pickedFile.path)));
    }
  }

  void clearFields() {
    emit(ProductFieldsCleared());
  }
}

abstract class ProductManagementState {}

class ProductManagementInitial extends ProductManagementState {}

class ProductImagePicked extends ProductManagementState {
  final File image;
  ProductImagePicked(this.image);
}

class ProductFieldsCleared extends ProductManagementState {}
