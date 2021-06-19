import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/components/UI/homePage/homepage.dart';
import 'package:time_tracker/provider/databaseProvider.dart';

class Navbar extends StatelessWidget {
  const Navbar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1,
        child: Consumer<DataBaseProvider>(
            builder: (buildContext, jobsProvider, _) {
          return Scaffold(
            body: HomePage(
                jobsProvider:
                    Provider.of<DataBaseProvider>(context, listen: false)),
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
                margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                items: [
                  /// Home
                  DotNavigationBarItem(
                    unselectedColor: Colors.grey,
                    icon: Icon(Icons.home),
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
              ),
            ),
          );
        }));
  }
}
