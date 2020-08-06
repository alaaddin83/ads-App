import 'dart:convert';

List<Pharmacy> pharmacyFromJson(String str) =>
    List<Pharmacy>.from(json.decode(str).map((x) => Pharmacy.fromJson(x)));

class Pharmacy {
  String date;
  String day;
  String pharName;
  String phone;
  String arabicAddress;
  String turkAddress;
  String mapadres;

  Pharmacy({
    this.date,
    this.day,
    this.pharName,
    this.phone,
    this.arabicAddress,
    this.turkAddress,
    this.mapadres,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) => Pharmacy(
        date: json["date"],
        //date: DateTime.parse(json["date"]),
        day: json["day"],
        pharName: json["phar_name"],
        phone: json["phone"],
        arabicAddress: json["arabic_address"],
        turkAddress: json["turk_address"],
        mapadres: json["location"],
      );

  Map<String, dynamic> toJson() => {
//    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "date": date,
        "day": day,
        "phar_name": pharName,
        "phone": phone,
        "arabic_address": arabicAddress,
        "turk_address": turkAddress,
        "location": mapadres,
      };
}
