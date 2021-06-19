import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/components/UI/auth/signin.dart';
import 'package:time_tracker/navbar.dart';
import 'package:time_tracker/provider/databaseProvider.dart';
import 'package:time_tracker/services/auth.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key key, this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: Provider.of<Auth>(context).authchanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final uid = Provider.of<Auth>(context).currentUser.uid;
          return ChangeNotifierProvider(
              create: (context) => DataBaseProvider(uid: uid), child: Navbar());
        }
        return SignInPage();
      },
    );
  }
}
