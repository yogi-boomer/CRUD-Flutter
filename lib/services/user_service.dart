import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:yipiempleado/models/models.dart';
import 'package:http/http.dart' as http;

class UserService extends ChangeNotifier {
  final String _baseURL = 'empleadosyipi-default-rtdb.firebaseio.com';
  final List<User> users = [];
  late User selectedUser;
  bool isLoading = true;
  bool isSaiving = false;

  File? newPictureFile;

  UserService() {
    loadUsuarios();
  }

  Future loadUsuarios() async {
    this.isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseURL, 'empleado.json');
    final resp = await http.get(url);

    final Map<String, dynamic> usuariosMap = json.decode(resp.body);
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
    if (user.id == null) {
      await this.createUser(user);
    } else {
      await this.updateUsuario(user);
    }

    isSaiving = false;
    notifyListeners();
  }

  Future<String> updateUsuario(User user) async {
    final url = Uri.https(_baseURL, 'empleado/${user.id}.json');
    final resp = await http.put(url, body: user.toJson());

    final decodedData = resp.body;

    //todo: actualizar lista de cambios
    final index = this.users.indexWhere((element) => element.id == user.id);
    this.users[index] = user;

    return user.id!;
  }

  Future<String> createUser(User user) async {
    final url = Uri.https(_baseURL, 'empleado.json');
    final resp = await http.post(url, body: user.toJson());
    final decodedData = json.decode(resp.body);

    //todo: actualizar lista de cambios
    user.id = decodedData['name'];
    this.users.add(user);

    return user.id!;
  }

  Future<String> deleteUser(User user) async {
    final url = Uri.https(_baseURL, 'empleado/${user.id}.json');
    final resp = await http.delete(url, body: user.toJson());
    final decodedData = json.decode(resp.body);

    //todo: actualizar lista de cambios
    final index = this.users.indexWhere((element) => element.id == user.id);
    this.users[index] = user;
    this.users.remove(user);

    return user.id!;
  }

  void updateSelectedUserImage(String path) {
    this.selectedUser.picture = path;
    this.newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (this.newPictureFile == null) return null;

    this.isSaiving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dp9d0caiu/image/upload?upload_preset=img_firebase');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    this.newPictureFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
