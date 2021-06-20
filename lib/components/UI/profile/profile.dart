import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/components/widgets/dialogs.dart';
import 'package:time_tracker/services/auth.dart';

class Profile extends StatelessWidget {
  const Profile({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AuthBase _auth = Provider.of<Auth>(context, listen: false);
    void _logout() {
      _auth.signout();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: Text('Profile'),
        actions: [
          // ignore: deprecated_member_use
          FlatButton(
              onPressed: () async {
                bool logoutConfirmed = await customDialogs(context, 'Log Out',
                    'Are you sure you want to log out?', 'Log Out', true);

                if (logoutConfirmed) {
                  _logout();
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Logout',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Icon(Icons.logout, size: 18, color: Colors.white),
                  )
                ],
              ))
        ],
      ),
      body: Container(
        color: Colors.indigo,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(width: 1)),
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.black54,
                backgroundImage: (_auth.currentUser.photoURL == null)
                    ? AssetImage('assets/images/user-Avatar.png')
                    : NetworkImage(_auth.currentUser.photoURL),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
                (_auth.currentUser.displayName != null)
                    ? _auth.currentUser.displayName
                    : 'user',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                )),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
