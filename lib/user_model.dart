// To parse this JSON data, do
//
//     final userDataModel = userDataModelFromJson(jsonString);

import 'dart:convert';

List<UserDataModel> userDataModelFromJson(String str) =>
    List<UserDataModel>.from(
        json.decode(str).map((x) => UserDataModel.fromJson(x)));

String userDataModelToJson(List<UserDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserDataModel {
  String q;
  String a;
  String h;

  UserDataModel({
    required this.q,
    required this.a,
    required this.h,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        q: json["q"],
        a: json["a"],
        h: json["h"],
      );

  Map<String, dynamic> toJson() => {
        "q": q,
        "a": a,
        "h": h,
      };
}
