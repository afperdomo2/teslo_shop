class ProductUser {
  String id;
  String email;
  String fullName;
  bool isActive;
  List<String> roles;

  ProductUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.isActive,
    required this.roles,
  });
}

class Product {
  String id;
  String title;
  int price;
  String description;
  String slug;
  int stock;
  List<String> sizes;
  String gender;
  List<String> tags;
  List<String> images;
  ProductUser user;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.slug,
    required this.stock,
    required this.sizes,
    required this.gender,
    required this.tags,
    required this.images,
    required this.user,
  });
}
