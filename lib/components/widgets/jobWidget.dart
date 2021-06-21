import 'package:flutter/material.dart';
import 'package:time_tracker/provider/databaseProvider.dart';

class JobWidget extends StatelessWidget {
  const JobWidget(
      {Key key, this.title, this.index, this.id, this.provider, this.onTap})
      : super(key: key);
  final String title;
  final int index;
  final String id;
  final dynamic onTap;
  final DataBaseProvider provider;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      child: ListTile(
        tileColor: Colors.white,
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
      ),
      background: Container(color: Colors.red),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await provider.deleteJob(id);
      },
    );
  }
}
