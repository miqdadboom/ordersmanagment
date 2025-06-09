import '../../../../core/repositories/base_repository.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../domain/entities/category.dart';
import '../models/category_model.dart';

class CategoryRepository extends BaseRepository<Category> {
  final FirebaseService _firebaseService = FirebaseService();

  CategoryRepository() : super(FirebaseService(), 'categories');

  @override
  Category fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel.fromMap(map, id);
  }

  @override
  Map<String, dynamic> toMap(Category item) {
    return (item as CategoryModel).toMap();
  }
}
