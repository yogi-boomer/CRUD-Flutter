import 'package:flutter/material.dart';
import 'dart:io';

class UserImage extends StatelessWidget {
  final String? url;

  const UserImage({Key? key, this.url}) : super(key: key);
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
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(45), topRight: Radius.circular(45)),
              child: getImage(url)),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45), topRight: Radius.circular(45)));

  Widget getImage(String? picture) {
    if (picture == null)
      return Image(image: AssetImage('assets/no-image.png'), fit: BoxFit.cover);
    if (picture.startsWith('http'))
      return FadeInImage(
        image: NetworkImage(this.url!),
        placeholder: AssetImage('assets/jar-loading.gif'),
        fit: BoxFit.cover,
      );

    return Image.file(
      File(picture),
      fit: BoxFit.cover,
    );
  }
}
