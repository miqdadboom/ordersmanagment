import 'dart:io';

abstract class ProductManagementState {}

class ProductInitial extends ProductManagementState {}

class ProductImagePicked extends ProductManagementState {
  final File image;
  ProductImagePicked(this.image);
}

class ProductError extends ProductManagementState {
  final String message;
  ProductError(this.message);
}