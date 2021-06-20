import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/components/UI/homePage/homepage.dart';
import 'package:time_tracker/provider/databaseProvider.dart';

import 'components/UI/profile/profile.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key key}) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(
          jobsProvider: Provider.of<DataBaseProvider>(context, listen: true)),
      Profile(),
      Profile()
    ];
    return Consumer<DataBaseProvider>(builder: (buildContext, jobsProvider, _) {
      return Scaffold(
        body: _pages.elementAt(selectedIndex),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withOpacity(.7),
                blurRadius: 20.0,
                spreadRadius: 5.0,
                offset: Offset(
                  15.0,
                  15.0,
                ),
              )
            ],
          ),
          height: 65,
          child: DotNavigationBar(
            currentIndex: selectedIndex,
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            items: [
              /// Home
              DotNavigationBarItem(
                unselectedColor: Colors.grey,
                icon: Icon(Icons.cases_rounded),
                selectedColor: Colors.indigo,
              ),

              /// Entry
              DotNavigationBarItem(
                unselectedColor: Colors.grey,
                icon: Icon(Icons.list),
                selectedColor: Colors.indigo,
              ),

              /// Profile
              DotNavigationBarItem(
                unselectedColor: Colors.grey,
                icon: Icon(Icons.person),
                selectedColor: Colors.indigo,
              ),
            ],
            onTap: (currentIndex) {
              setState(() {
                selectedIndex = currentIndex;
              });
            },
          ),
        ),
      );
    });
  }
}
