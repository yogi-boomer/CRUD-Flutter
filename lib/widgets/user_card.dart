import 'package:flutter/material.dart';
import 'package:yipiempleado/models/models.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({
    Key? key,
    required this.user
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: _cardBorders(),
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            _BackgroundImage(user.picture),
            _UserDetails(
              title: user.nombre,
              subtitle: user.departamento,
            ),

            Positioned(
              top: 0,
              right: 0,
              child: _UserSalary(
                salario: user.salario,
              )
              ),

            Positioned(
              top: 0,
              left: 0,
              child: _UserId(
                id: user.id!,
              )
              ),  
          ],
        ),
      margin: EdgeInsets.only(top: 30, bottom: 50),
      width: double.infinity,
      height: 400,) 
    );
  }

  BoxDecoration _cardBorders() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius:  BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset:  Offset(5,9),
            blurRadius: 15
          ),
        ],
      );
  }
}

class _UserId extends StatelessWidget {
  final String id;

  const _UserId({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(id, 
          style:
           TextStyle( fontWeight: FontWeight.bold, color: Colors.white,fontSize: 15),
          ),
        ),
      ),
      width: 180,
      height: 80,
      decoration:const BoxDecoration(
      color: Colors.purple,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(25), topLeft: Radius.circular(20))
      ),
    );
  }
}

class _UserSalary extends StatelessWidget {
  final int salario;

  const _UserSalary({Key? key, required this.salario}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
           'Salario \$$salario' , 
          style:
           TextStyle( fontWeight: FontWeight.normal, color: Colors.white,fontSize: 15),
          ),
        ),
      ),
      width: 180,
      height: 80,
      decoration:const BoxDecoration(
      color: Colors.indigo,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), topRight: Radius.circular(20))
      ),
    );
  }
}

class _UserDetails extends StatelessWidget {
 final String title;
 final String subtitle;

  const _UserDetails({ required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 50),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children :  <Widget> [
          Text(
            title,
            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,),
          Text(subtitle,
            style: TextStyle(fontSize: 15, color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,),
        ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.indigo,
    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), topRight: Radius.circular(20))
  );
}

class _BackgroundImage extends StatelessWidget {
 final String? url;

  const _BackgroundImage( this.url);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child:  Container(
      width: double.infinity,
      height: 400,
      child: url == null 
      ? Image(image: AssetImage('assets/no-image.png'),
      fit: BoxFit.cover,):
       FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(url!),
        fit: BoxFit.cover,
      ),
    ),
    );
   
  }
}