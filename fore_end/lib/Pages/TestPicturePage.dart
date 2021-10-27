import 'dart:convert';

import 'package:flutter/cupertino.dart';

class TestPicturePage extends StatelessWidget {
  String base64;
  TestPicturePage(this.base64) : super();
  @override
  Widget build(BuildContext context) {
    return Image.memory(base64Decode(this.base64));
  }
}
