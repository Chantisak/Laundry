// To parse this JSON data, do
//
//     final getLaundryModel = getLaundryModelFromJson(jsonString);

import 'dart:convert';

List<GetLaundryModel> getLaundryModelFromJson(String str) =>
    List<GetLaundryModel>.from(
        json.decode(str).map((x) => GetLaundryModel.fromJson(x)));

String getLaundryModelToJson(List<GetLaundryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetLaundryModel {
  GetLaundryModel({
    this.id,
    this.status,
    this.price,
    this.userid,
  });

  String? id;
  String? status;
  String? price;
  String? userid;

  factory GetLaundryModel.fromJson(Map<String, dynamic> json) =>
      GetLaundryModel(
        id: json["id"],
        status: json["status"],
        price: json["price"],
        userid: json["userid"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "price": price,
        "userid": userid ?? null,
      };
}
