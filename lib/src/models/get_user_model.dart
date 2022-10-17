// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.money,
  });

  String? money;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        money: json["money"],
      );

  Map<String, dynamic> toJson() => {
        "money": money,
      };
}
