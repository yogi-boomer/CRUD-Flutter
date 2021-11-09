import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yipiempleado/providers/user_form_provider.dart';
import 'package:yipiempleado/services/services.dart';
import 'package:yipiempleado/ui/input_decoration.dart';
import 'package:yipiempleado/widgets/widgets.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    return ChangeNotifierProvider(
      create: (_) => UserFormProvider(userService.selectedUser),
      child: _UserScreenBody(userService: userService),
    );
  }
}

class _UserScreenBody extends StatelessWidget {
  const _UserScreenBody({
    Key? key,
    required this.userService,
  }) : super(key: key);

  final UserService userService;

  @override
  Widget build(BuildContext context) {
    final userform = Provider.of<UserFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        // padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                UserImage(url: userService.selectedUser.picture),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'home');
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    onPressed: () async {
                      final picker = new ImagePicker();
                      final PickedFile? pickedFile = await picker.getImage(
                          source: ImageSource.gallery, imageQuality: 100);

                      if (pickedFile == null) {
                        print('No seleccionó nada');
                        return;
                      }
                      userService.updateSelectedUserImage(pickedFile.path);
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                Positioned(
                  top: 400,
                  right: 20,
                  child: IconButton(
                    onPressed: () async {
                      if (!userform.isValidForm()) return;
                      await userService.deleteUser(userform.user);

                      Navigator.pushNamed(context, 'home');
                    },
                    icon: const Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
            _UserForm(),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: userService.isSaiving
            ? CircularProgressIndicator(color: Colors.white)
            : Icon(Icons.save),
        onPressed: userService.isSaiving
            ? null
            : () async {
                if (!userform.isValidForm()) return;

                final String? imageUrl = await userService.uploadImage();

                if (imageUrl != null) userform.user.picture = imageUrl;

                print(imageUrl);

                await userService.saveOrCreateUser(userform.user);
                //userService.saveOrCreateUser(userform.user);
                //Navigator.popAndPushNamed(context, 'home');
              },
      ),
    );
  }
}

class _UserForm extends StatelessWidget {
  const _UserForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userForm = Provider.of<UserFormProvider>(context);
    final user = userForm.user;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: userForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: user.nombre,
                onChanged: (value) => user.nombre = value,
                validator: (value) {
                  if (value == null || value.length < 1) {
                    return 'El nombre del trabajador es obligatorio';
                  }
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nombre de usuario', labelText: 'Nombre'),
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: user.departamento,
                onChanged: (value) => user.departamento = value,
                validator: (value) {
                  if (value == null || value.length < 1) {
                    return 'El departamento del trabajador es obligatorio';
                  }
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Departamento', labelText: 'Departamento'),
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: user.salario.toString(),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  if (int.tryParse(value) == null) {
                    user.salario = 0;
                  } else {
                    user.salario = int.parse(value);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'salario', labelText: 'Salario'),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)));
}
