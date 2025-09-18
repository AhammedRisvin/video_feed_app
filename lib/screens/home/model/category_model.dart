class CategoryModel {
  List<Category>? categories;
  bool? status;

  CategoryModel({this.categories, this.status});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    categories: json["categories"] == null
        ? []
        : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "status": status,
  };
}

class Category {
  int? id;
  String? title;
  String? image;

  Category({this.id, this.title, this.image});

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(id: json["id"], title: json["title"], image: json["image"]);

  Map<String, dynamic> toJson() => {"id": id, "title": title, "image": image};
}
