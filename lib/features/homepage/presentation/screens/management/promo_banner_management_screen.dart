// main screen: promo_banner_management_screen.dart
import 'package:final_tasks_front_end/core/constants/app_size_box.dart';
import 'package:final_tasks_front_end/features/homepage/data/firebase/promo_banner_repository.dart';
import 'package:final_tasks_front_end/features/homepage/data/models/promo_banner.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/widgets/promo_banner_management/confirm_delete_dialog.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/widgets/promo_banner_management/edit_promo_banner_dialog.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/widgets/promo_banner_management/promo_banner_form.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/widgets/promo_banner_management/promo_banner_list.dart';
import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/constants/custom_app_bar.dart';
import 'dart:io';

class PromoBannerManagementScreen extends StatefulWidget {
  const PromoBannerManagementScreen({super.key});

  @override
  State<PromoBannerManagementScreen> createState() =>
      _PromoBannerManagementScreenState();
}

class _PromoBannerManagementScreenState
    extends State<PromoBannerManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final PromoBannerRepository _repository = PromoBannerRepository();
  File? _imageFile;
  bool _isLoading = false;
  PromoBannerModel? _editingBanner;

  void _resetForm() {
    setState(() {
      _imageFile = null;
      _titleController.clear();
      _descriptionController.clear();
      _editingBanner = null;
    });
  }

  void _editBanner(PromoBannerModel banner) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => EditPromoBannerDialog(banner: banner, onUpdated: () {}),
    );
  }

  Future<void> _deleteBanner(PromoBannerModel banner) async {
    final confirmed = await showConfirmDeleteDialog(context);
    if (confirmed == true) {
      try {
        await _repository.deleteImage(banner.imageUrl);
        await _repository.deleteBanner(banner.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Banner deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete banner: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Promo Banner Management',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PromoBannerForm(
              formKey: _formKey,
              titleController: _titleController,
              descriptionController: _descriptionController,
              imageFile: _imageFile,
              isLoading: _isLoading,
              editingBanner: _editingBanner,
              onImagePicked: (file) => setState(() => _imageFile = file),
              onReset: _resetForm,
              onLoadingChanged: (val) => setState(() => _isLoading = val),
            ),
            AppSizedBox.height(context, 0.04), // 4% تقريبًا من ارتفاع الشاشة
            PromoBannerList(onEdit: _editBanner, onDelete: _deleteBanner),
          ],
        ),
      ),
    );
  }
}
