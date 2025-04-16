import 'dart:io';

import 'package:image_picker/image_picker.dart';


class WorkshopsModel {
  final int? id;
  final String? logo;
  final String? owner;
  final String? workshop_name;
  final String? location;
  final String? employee;
  final String? city;
  final String? tax_number;
  final String? legal_number;
  final String? created_at;
  final String? updated_at;
  // final List<BrandCategoriesModel>? categories;
  // final List<BrandCategoriesModel>? brands;

  final String? whatsapp_number;
  final String? phone;
  final double? lat;
  final double? lng;
  final List<SelectedDays>? days;
  final List<dynamic>? images;


  WorkshopsModel({

    this.id,
    this.logo,
    this.owner,
    this.workshop_name,
    this.location,
    this.employee,
    this.city,
    this.tax_number,
    this.legal_number,
    this.created_at,
    this.updated_at,
    // this.usertype,

    this.whatsapp_number,
    this.phone,
    this.lat,
    this.lng,
    // this.categories,
    // this.brands,
    this.days,
    this.images


  });



  factory WorkshopsModel.fromJson(Map<String, dynamic> json) {
    return WorkshopsModel(
      id: json['id'],
      logo: json['logo'],
      employee: json['employee'],
      location: json['location'],
      city: json['city'],
      tax_number: json['tax_number'],
      legal_number: json['legal_number'],
      owner: json['owner'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      workshop_name: json['workshop_name'],
      phone: json['phone'],
      whatsapp_number: json['whatsapp_number'],
      lat: json['lat'],
      lng: json['lng'],
      images : json['images'] != null ?json['images'].cast<dynamic>():null,

      days: List<SelectedDays>.from(
          json['days'].map((x) => SelectedDays.fromJson(x))),
      // categories:
      // brands:


    );
  }

// Map<String, dynamic> toJson() {
//   return {
//     'id': id,
//     'name': name,
//     'email': email,
//     'role': role,
//     'email_verified_at': emailVerifiedAt?.toIso8601String(),
//     'phone': phone,
//     'register_certificate': registerCertificate,
//     'commercial_certificate': commercialCertificate,
//     'licenses': licenses,
//     'status': status,
//     'created_at': createdAt.toIso8601String(),
//     'updated_at': updatedAt.toIso8601String(),
//   };
// }




}

class SelectedDays {
  final String? day;
  final String? from;
  final String? to;



  SelectedDays({
    this.day,
    this.from,
    this.to,


  });

  factory SelectedDays.fromJson(Map<String, dynamic> json) {
    return SelectedDays(
      day: json['day'],
      from: json['from'],
      to: json['to'],


    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'from': from,
      'to': to,

    };
  }
















}

class BrandCategoriesModel {
  final int? id;
  final String? name;
  final String? image;



  BrandCategoriesModel({
    this.id,
    this.name,
    this.image,


  });

  factory BrandCategoriesModel.fromJson(Map<String, dynamic> json) {
    return BrandCategoriesModel(
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
