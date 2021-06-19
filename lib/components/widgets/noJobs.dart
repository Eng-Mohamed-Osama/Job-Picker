import 'package:flutter/material.dart';

class Nojobs extends StatelessWidget {
  const Nojobs({Key key, this.mainText, this.subText}) : super(key: key);
  final String mainText;
  final String subText;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(mainText,
              style: TextStyle(
                fontSize: 32,
                color: Colors.black54,
              )),
          Text(subText,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              )),
        ],
      ),
    );
  }
}
