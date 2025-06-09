import 'dart:io';
import 'package:final_tasks_front_end/core/constants/app_size_box.dart';
import 'package:final_tasks_front_end/features/homepage/data/firebase/promo_banner_repository.dart';
import 'package:final_tasks_front_end/features/homepage/data/models/promo_banner.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditPromoBannerDialog extends StatefulWidget {
  final PromoBannerModel banner;
  final VoidCallback onUpdated;

  const EditPromoBannerDialog({
    super.key,
    required this.banner,
    required this.onUpdated,
  });

  @override
  State<EditPromoBannerDialog> createState() => _EditPromoBannerDialogState();
}

class _EditPromoBannerDialogState extends State<EditPromoBannerDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _newImageFile;
  bool _isLoading = false;
  final PromoBannerRepository _repository = PromoBannerRepository();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.banner.title;
    _descriptionController.text = widget.banner.description;
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
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      String? imageUrl = widget.banner.imageUrl;
      if (_newImageFile != null) {
        imageUrl = await _repository.uploadImage(_newImageFile!);
      }
      await _repository.updateBanner(
        bannerId: widget.banner.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: imageUrl,
      );
      widget.onUpdated();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Banner updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update banner: $e'),
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
      title: const Text('Edit Promo Banner', textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child:
                    _newImageFile != null
                        ? Image.file(
                          _newImageFile!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                        : (widget.banner.imageUrl.isNotEmpty
                            ? Image.network(
                              widget.banner.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                            : Container(
                              width: 80,
                              height: 80,
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
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            AppSizedBox.height(context, 0.015),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
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
