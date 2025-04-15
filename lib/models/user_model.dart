class UserModel {
  int? id;
  String? userType;
  String? image;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  int? accountStatus;
  String? city;
  double? latitude;
  double? longitude;
  String? location;
  String? createdAt;
  String? updatedAt;

  UserModel({
    this.id,
    this.userType,
    this.image,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.accountStatus,
    this.city,
    this.latitude,
    this.longitude,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method to parse from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userType: json['usertype'],
      image: json['image'],
      firstName: json['fname'],
      lastName: json['lname'],
      phone: json['phone'],
      email: json['email'],
      accountStatus: json['acc_status'],
      city: json['city'],
      latitude: json['lat'] != null ? json['lat'].toDouble() : null,
      longitude: json['lng'] != null ? json['lng'].toDouble() : null,
      location: json['location'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Method to convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usertype': userType,
      'image': image,
      'fname': firstName,
      'lname': lastName,
      'phone': phone,
      'email': email,
      'acc_status': accountStatus,
      'city': city,
      'lat': latitude,
      'lng': longitude,
      'location': location,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
