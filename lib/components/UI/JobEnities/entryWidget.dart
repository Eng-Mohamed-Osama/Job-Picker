import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/models/entry.dart';
import 'package:time_tracker/provider/databaseProvider.dart';

class EntryWidget extends StatelessWidget {
  const EntryWidget({Key key, this.entry, this.provider}) : super(key: key);
  final Entry entry;

  final DataBaseProvider provider;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(entry.id),
      child: ListTile(
        tileColor: Colors.white,
        trailing: Icon(Icons.chevron_right),
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Start  : ${DateFormat('EEE, MMM d, ' 'h:mm a').format(entry.start).toString()}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal)),
                    Text(
                        'End  : ${DateFormat('EEE, MMM d, ' 'h:mm a').format(entry.end).toString()}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal)),
                    Opacity(
                      opacity: .7,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Container(
                          width: 200,
                          child: Text(entry.comment,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('\$ ${entry.entryRate.toString()}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[400],
                      )),
                  Text(
                      '${entry.end.difference(entry.start).inHours.toString()} h',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              )
            ]),
      ),
      background: Container(color: Colors.red),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await provider.deleteEntry(entry.id);
      },
    );
  }
}
