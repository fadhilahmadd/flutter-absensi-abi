// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<Pengguna> userFromJson(String str) => List<Pengguna>.from(json.decode(str).map((x) => Pengguna.fromJson(x)));

String userToJson(List<Pengguna> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pengguna {
    int id;
    String username;

    Pengguna({        
        required this.id,
        required this.username
    });

    factory Pengguna.fromJson(Map<String, dynamic> json) => Pengguna(        
        id: json["id"],
        username: json["name"],
    );

    Map<String, dynamic> toJson() => {        
        "id": id,
        "username": username,
    };

  @override
  String toString(){
    String result = username;
    return result;
  }

}
