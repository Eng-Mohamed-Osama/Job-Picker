// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/components/UI/auth/email_and_password.dart';
import 'package:time_tracker/components/widgets/sing_in_buttons.dart';
import 'package:time_tracker/services/auth.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  _SignInPage createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  bool isloading = false;

  Future<void> _signinanonymous(context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    try {
      setState(() {
        isloading = true;
      });
      await auth.signinAnonmous();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  Future<void> _signinwithGoogle(context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    try {
      setState(() {
        isloading = true;
      });
      await auth.signinWithGoogle();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  Future<void> _signinWithFacebook(context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    try {
      setState(() {
        isloading = true;
      });
      await auth.signinWithFacebook();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Center(
            child: Text(
          'Planogo',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        )),
        elevation: 5,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text('Sign in',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w600)),
            ),
            SizedBox(height: 48),
            SignInButton(
              color: Colors.white,
              textcolor: Colors.black,
              text: 'Sign in with Google',
              h: 30,
              w: 30,
              fun: (!isloading) ? () => _signinwithGoogle(context) : null,
            ),
            SignInButton(
              color: Color(0xFF334D92),
              text: 'Sign in with Facebook',
              imgLink: 'assets/images/Facebook_icon_2013.svg.png',
              h: 30,
              w: 30,
              fun: (!isloading) ? () => _signinWithFacebook(context) : null,
            ),
            SignInButton(
              color: Colors.teal[700],
              text: 'Sign in with Email',
              h: 0,
              w: 0,
              fun: (!isloading)
                  ? () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmailAndPassword()),
                        ).then((_) => setState(() {
                              isloading = false;
                            }))
                      }
                  : null,
            ),
            Text(
              'or',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600),
            ),
            SignInButton(
              color: Colors.lime[700],
              text: 'Go anonymous',
              h: 0,
              w: 0,
              fun: (!isloading) ? () => _signinanonymous(context) : null,
            ),
          ],
        ),
      ),
    );
  }
}
