import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/components/widgets/dialogs.dart';
import 'package:time_tracker/services/auth.dart';

class EmailAndPassword extends StatefulWidget {
  const EmailAndPassword({Key key}) : super(key: key);
  @override
  _EmailAndPasswordState createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool fristTimeUser = false;
  bool loading = false;

  Future<void> _signUp() async {
    setState(() {
      loading = true;
    });
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      await auth
          .signUpwithEmail(
              email: emailController.text, password: passwordController.text)
          .then((_) => Navigator.pop(context));
    } on FirebaseAuthException catch (e) {
      customDialogs(context, 'Erorr', e.message, 'Ok', false);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _signIn() async {
    setState(() {
      loading = true;
    });
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      await auth
          .signinwithEmail(
              email: emailController.text, password: passwordController.text)
          .then((_) => Navigator.pop(context));
    } on FirebaseAuthException catch (e) {
      customDialogs(context, 'Erorr', e.message, 'Ok', false);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void _submit() {
    if (fristTimeUser) {
      _signUp();
    } else {
      _signIn();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: (fristTimeUser)
              ? Text(
                  'Sing up',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                )
              : Text(
                  'Sing In',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                ),
          elevation: 5,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Card(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                            controller: emailController,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            enabled: loading == false,
                            onChanged: (value) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'example@mail.com')),
                        SizedBox(height: 8),
                        TextField(
                            controller: passwordController,
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            enabled: loading == false,
                            onChanged: (value) {
                              setState(() {});
                            },
                            onEditingComplete:
                                (passwordController.text.isNotEmpty &&
                                        emailController.text.isNotEmpty &&
                                        (loading == false))
                                    ? () => _submit()
                                    : null,
                            decoration: InputDecoration(
                              labelText: 'Password',
                            )),
                        SizedBox(height: 8),
                        // ignore: deprecated_member_use
                        RaisedButton(
                          color: Colors.lightBlue,
                          child: (fristTimeUser)
                              ? Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text('Create Account',
                                      style: TextStyle(fontSize: 20)),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text('Sing in',
                                      style: TextStyle(fontSize: 20)),
                                ),
                          onPressed: (passwordController.text.isNotEmpty &&
                                  emailController.text.isNotEmpty &&
                                  (loading == false))
                              ? () => _submit()
                              : null,
                        ),
                        // ignore: deprecated_member_use
                        FlatButton(
                            onPressed: () {
                              setState(() {
                                fristTimeUser = !fristTimeUser;
                                passwordController.clear();
                                emailController.clear();
                              });
                            },
                            child: (fristTimeUser)
                                ? Text('Have An Account? Sign In')
                                : Text('Need An Account? Register'))
                      ]),
                ),
              ),
            ),
          ),
        ));
  }
}
