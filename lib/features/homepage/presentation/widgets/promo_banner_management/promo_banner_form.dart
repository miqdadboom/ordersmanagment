import 'dart:io';
import 'package:final_tasks_front_end/core/constants/app_size_box.dart';
import 'package:final_tasks_front_end/features/homepage/data/firebase/promo_banner_repository.dart';
import 'package:final_tasks_front_end/features/homepage/data/models/promo_banner.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/widgets/product_management/custom_text_field.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/widgets/product_management/image_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PromoBannerForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final File? imageFile;
  final bool isLoading;
  final PromoBannerModel? editingBanner;
  final Function(File file) onImagePicked;
  final VoidCallback onReset;
  final Function(bool) onLoadingChanged;

  const PromoBannerForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.imageFile,
    required this.isLoading,
    required this.editingBanner,
    required this.onImagePicked,
    required this.onReset,
    required this.onLoadingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final PromoBannerRepository _repository = PromoBannerRepository();

    Future<void> pickImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        onImagePicked(File(pickedFile.path));
      }
    }

    Future<void> saveBanner() async {
      if (!formKey.currentState!.validate() || imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image and fill all fields.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      if (editingBanner == null) {
        final existing = await _repository.getBanners().first;
        if (existing.length >= 4) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text(
                    'Limit Reached',
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'You can only have 4 promo banners.',
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'Please delete at least one banner to add a new one.\n',
                            ),
                            TextSpan(
                              text: 'Delete one',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' to continue.'),
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
      }

      onLoadingChanged(true);
      try {
        final imageUrl = await _repository.uploadImage(imageFile!);
        if (editingBanner != null) {
          await _repository.updateBanner(
            bannerId: editingBanner!.id,
            title: titleController.text.trim(),
            description: descriptionController.text.trim(),
            imageUrl: imageUrl,
          );
        } else {
          await _repository.addBanner(
            title: titleController.text.trim(),
            description: descriptionController.text.trim(),
            imageUrl: imageUrl,
          );
        }
        onReset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save banner: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        onLoadingChanged(false);
      }
    }

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ImagePickerWidget(image: imageFile, onTap: pickImage),
          AppSizedBox.height(context, 0.03),
          CustomTextField(
            controller: titleController,
            hintText: 'Banner Title',
            icon: Icons.title,
            validatorMessage: 'Please enter a title',
          ),
          CustomTextField(
            controller: descriptionController,
            hintText: 'Banner Description',
            icon: Icons.description,
            validatorMessage: 'Please enter a description',
          ),
          AppSizedBox.height(context, 0.04),
          ElevatedButton(
            onPressed: isLoading ? null : saveBanner,
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
                Text(editingBanner != null ? 'Update Banner' : 'Save Banner'),
                if (isLoading) ...[
                  const SizedBox(width: 12),
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
