import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textcolor;
  final double w;
  final double h;
  final String imgLink;
  final dynamic fun;
  const SignInButton({
    Key key,
    this.text = '',
    this.fun,
    this.w = 0,
    this.h = 0,
    this.imgLink = 'assets/images/google.png',
    this.textcolor = Colors.white,
    this.color = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 5, 20, 5),
        child: SizedBox(
          height: 50,
          // ignore: deprecated_member_use
          child: RaisedButton(
            disabledColor: this.color,
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: this.color,
            onPressed: this.fun,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image(
                  image: AssetImage(this.imgLink),
                  width: this.w,
                  height: this.w,
                ),
                // ),
                Text('${this.text}',
                    style: TextStyle(color: this.textcolor, fontSize: 18)),
                Opacity(
                  opacity: 0,
                  child: Image(
                    image: AssetImage(this.imgLink),
                    width: this.w,
                    height: this.w,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
