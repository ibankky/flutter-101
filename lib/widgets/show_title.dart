import 'package:flutter/material.dart';
import 'package:flutter_application_demo/utility/my_constant.dart';

class ShowTitle extends StatelessWidget {
  String? title;
  TextStyle? textStyle;
  ShowTitle({@required this.title , @required this.textStyle});
  @override
  Widget build(BuildContext context) {
    return Text(
      title!,
      style: textStyle ,
    );
  }
}
