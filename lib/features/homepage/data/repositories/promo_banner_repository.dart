import 'dart:io';
import '../../../../core/repositories/base_repository.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../domain/entities/promo_banner.dart';
import '../models/promo_banner.dart';

class PromoBannerRepository extends BaseRepository<PromoBanner> {
  final FirebaseService _firebaseService = FirebaseService();

  PromoBannerRepository() : super(FirebaseService(), 'promo_banners');

  @override
  PromoBanner fromMap(Map<String, dynamic> map, String id) {
    return PromoBannerModel.fromMap(map, id);
  }

  @override
  Map<String, dynamic> toMap(PromoBanner item) {
    return (item as PromoBannerModel).toMap();
  }

  Future<String> uploadImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return await _firebaseService.uploadFile(
      'promo_banners/${DateTime.now().millisecondsSinceEpoch}.jpg',
      bytes,
    );
  }

  Future<void> deleteImage(String imageUrl) async {
    await _firebaseService.deleteFile(imageUrl);
  }
}
