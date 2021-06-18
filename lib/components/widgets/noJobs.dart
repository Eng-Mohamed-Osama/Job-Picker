import 'package:flutter/material.dart';

class Nojobs extends StatelessWidget {
  const Nojobs({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Nothing here',
              style: TextStyle(
                fontSize: 32,
                color: Colors.black54,
              )),
          Text('Add a new item to get started',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              )),
        ],
      ),
    );
  }
}
