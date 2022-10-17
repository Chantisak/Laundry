// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    LoginModel({
        this.token,
        this.name,
        this.message,
        this.status,
    });

    String? token;
    String? name;
    String? message;
    String? status;

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        token: json["token"],
        name: json["name"],
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "name": name,
        "message": message,
        "status": status,
    };
}
