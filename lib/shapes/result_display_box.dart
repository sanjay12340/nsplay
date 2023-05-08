import 'package:flutter/cupertino.dart';

class ClipClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width - 40, size.height);
    path.quadraticBezierTo(
        size.width - 40, size.height, size.width - 20, size.height);
    path.lineTo(size.width - 20, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
