import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {

  final String? url;

  const UserImage({
    Key? key,
    this.url
    }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        width: double.infinity,
        height: 450,
        decoration: _buildBoxDecoration(),
        child: Opacity(
          opacity: 0.9,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
            child: url == null 
            ?  Image(
              image: AssetImage('assets/no-image.png'),
              fit:  BoxFit.cover,):
            FadeInImage(
              image: NetworkImage(url!),
              placeholder: AssetImage('assets/jar-loading.gif'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.black,
    borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45))
  );
}