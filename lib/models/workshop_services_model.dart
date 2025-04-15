class WorkshopServicesModel {
  final int? id;
  final String? name;
  final String? image;

  WorkshopServicesModel(
      {required this.id, required this.name, required this.image});

  factory WorkshopServicesModel.fromJson(Map<String, dynamic> json) {
    return WorkshopServicesModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}
