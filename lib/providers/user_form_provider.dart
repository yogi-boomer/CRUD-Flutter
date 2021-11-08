
import 'package:flutter/material.dart';
import 'package:yipiempleado/models/models.dart';

class UserFormProvider extends ChangeNotifier{

    GlobalKey<FormState> formKey = new GlobalKey<FormState>();

    User user;
    UserFormProvider(this.user);
    bool isValidForm(){
    print(user.nombre);
    print(user.departamento);
    print(user.salario);
    
    return formKey.currentState?.validate() ?? false;
  }


}