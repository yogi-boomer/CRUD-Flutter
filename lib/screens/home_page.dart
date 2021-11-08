import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yipiempleado/models/models.dart';
import 'package:yipiempleado/screens/loading_scrreen.dart';
import 'package:yipiempleado/services/services.dart';
import 'package:yipiempleado/widgets/user_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usuariosService = Provider.of<UserService>(context);
    if (usuariosService.isLoading) return LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Usuarios en YipiStudios'),
      ),
      body: ListView.builder(
          itemCount: usuariosService.users.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: () {
                 usuariosService.selectedUser = usuariosService.users[index].copy();
                 Navigator.pushNamed(context, 'user');
              },
              child: UserCard(
                user: usuariosService.users[index],
             ) 
           )
         ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: () {

          usuariosService.selectedUser = new User(
            salario: 0,
            departamento: '',
            nombre: '');
          Navigator.pushNamed(context, 'user');
        },
      ),
    );
  }
}
