class CategoryModel {
  final String name;
  final String file;

  CategoryModel({required this.name, required this.file});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'] as String,
      file: json['file'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'file': file};
  }
}
