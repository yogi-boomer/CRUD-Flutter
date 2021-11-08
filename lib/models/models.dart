// To parse this JSON data, do
//     final user = userFromMap(jsonString);

import 'dart:convert';

class User {
    User({
        required this.salario,
        required  this.departamento,
        required  this.nombre,
        this.picture,
        this.id
    });

    int salario;
    String departamento;
    String nombre;
    String? picture;
    String? id;

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        salario: json["Salario"],
        departamento: json["departamento"],
        nombre: json["nombre"],
        picture: json["picture"],
    );

    Map<String, dynamic> toMap() => {
        "Salario": salario,
        "departamento": departamento,
        "nombre": nombre,
        "picture": picture,
    };

    User copy() => User(
      salario: this.salario,
      departamento: this.departamento,
      nombre: this.nombre,
      picture: this.picture,
      id: this.id
    );
    
}