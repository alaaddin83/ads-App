// To parse this JSON data, do
//
//     final imageItem = imageItemFromJson(jsonString);

import 'dart:convert';

List<ImageItem> imageItemFromJson(String str) => List<ImageItem>.from(json.decode(str).map((x) => ImageItem.fromJson(x)));

String imageItemToJson(List<ImageItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ImageItem {
  String imgSrc;
  String contact;

  ImageItem({
    this.imgSrc,
    this.contact,
  });

  factory ImageItem.fromJson(Map<String, dynamic> json) => ImageItem(
    imgSrc: json["img_src"],
    contact: json["contact"],
  );

  Map<String, dynamic> toJson() => {
    "img_src": imgSrc,
    "contact": contact,
  };
}
