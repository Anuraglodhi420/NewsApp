import 'package:newshub/models/category_model.dart';

List<CategoryModel> getCategories() {
  List<CategoryModel> category = [];
  CategoryModel categoryModel = new CategoryModel();

  categoryModel.categoryName = "Business";
  categoryModel.image = "images/b.jpg";
  category.add(categoryModel);
  categoryModel = new CategoryModel();

  categoryModel.categoryName = "Entertainment";
  categoryModel.image = "images/ent.jpg";
  category.add(categoryModel);
  categoryModel = new CategoryModel();

  categoryModel.categoryName = "General";
  categoryModel.image = "images/g.jpg";
  category.add(categoryModel);
  categoryModel = new CategoryModel();

  categoryModel.categoryName = "Health";
  categoryModel.image = "images/h.jpg";
  category.add(categoryModel);
  categoryModel = new CategoryModel();

  categoryModel.categoryName = "Science";
  categoryModel.image = "images/s.jpg";
  category.add(categoryModel);
  categoryModel = new CategoryModel();

  categoryModel.categoryName = "Sports";
  categoryModel.image = "images/sports.jpg";
  category.add(categoryModel);
  categoryModel = new CategoryModel();

  return category;
}
