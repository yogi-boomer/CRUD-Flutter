


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:yipiempleado/models/models.dart';
import 'package:http/http.dart' as http;
class UserService extends ChangeNotifier{

    final String _baseURL = 'empleadosyipi-default-rtdb.firebaseio.com';
    final List<User> users = [];
    late User selectedUser;
    bool isLoading = true;
    bool isSaiving = false;

    UserService(){
      loadUsuarios();
    }

    Future loadUsuarios() async{
      this.isLoading = true;
      notifyListeners();
      final url = Uri.https(_baseURL, 'empleado.json');
      final resp = await http.get(url);

      final Map<String,dynamic> usuariosMap = json.decode(resp.body);
      usuariosMap.forEach((key, value) {
        final tempUser = User.fromMap(value);
        tempUser.id = key;
        users.add(tempUser);

      });
      this.isLoading = false;
      notifyListeners();
    }


  Future saveOrCreateUser(User user) async {

    isSaiving = true;
    notifyListeners();
    if(user.id  == null){
      await this.createUser(user);
    }else{
      await this.updateUsuario(user);
    }

    isSaiving = false;
    notifyListeners();


  }

  Future<String> updateUsuario (User  user) async {
      final url = Uri.https(_baseURL, 'empleado/${user.id}.json');
      final resp = await http.put(url, body: user.toJson());

      final decodedData = resp.body;

      //todo: actualizar lista de cambios 
      final index = this.users.indexWhere((element) => element.id == user.id);
      this.users[index] = user;

    return user.id!;
  }

  Future<String> createUser (User  user) async {
      final url = Uri.https(_baseURL, 'empleado.json');
      final resp = await http.post(url, body: user.toJson());
      final decodedData = json.decode(resp.body) ;

      //todo: actualizar lista de cambios 
      user.id = decodedData['name'];
      this.users.add(user);

    return user.id!;
  }

  Future<String> deleteUser (User  user) async {
      final url = Uri.https(_baseURL, 'empleado/${user.id}.json');
      final resp = await http.delete(url, body: user.toJson());
      final decodedData = json.decode(resp.body) ;

      //todo: actualizar lista de cambios 
      final index = this.users.indexWhere((element) => element.id == user.id);
      this.users[index] = user;
      this.users.remove(user);

    return user.id!;
  }



}