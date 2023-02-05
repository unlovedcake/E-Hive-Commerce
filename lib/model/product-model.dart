class ProductModel {
  int? id;
  String? title;
  String? description;
  double? price;
  double? discountPercentage;
  double? rating;
  int? stock;
  String? brand;
  String? category;
  String? thumbnail;
  int qty = 0;
  List<String>? images;

  ProductModel({
    this.id,
    this.title,
    this.description,
    this.price,
    this.discountPercentage,
    this.rating,
    this.stock,
    this.brand,
    this.category,
    this.thumbnail,
    required this.qty,
    this.images,
  });

// receiving data from server

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      discountPercentage: json['discountPercentage'].toDouble(),
      rating: json['rating'].toDouble(),
      stock: json['stock'],
      brand: json['brand'],
      category: json['category'],
      thumbnail: json['thumbnail'],
      qty: json['qty'] ?? 0,
      images: List<String>.from(json['images']),
    );
  }
}

class ProductListModel {
  List<ProductModel>? productData;
  int? total;
  int? skip;
  int? limit;

  ProductListModel(this.total, this.skip, this.limit, this.productData);

  factory ProductListModel.fromMap(Map<String, dynamic> data) {
    return ProductListModel(
      data['total'],
      data['skip'],
      data['limit'],
      (data['products'] as List).map((itemWord) => ProductModel.fromJson(itemWord)).toList(),
    );
  }
}
