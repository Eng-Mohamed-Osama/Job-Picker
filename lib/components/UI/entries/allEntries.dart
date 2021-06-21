import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:time_tracker/components/widgets/noJobs.dart';
import 'package:time_tracker/models/entry.dart';
import 'package:time_tracker/provider/databaseProvider.dart';

class AllEntries extends StatelessWidget {
  const AllEntries({Key key, this.dataBase}) : super(key: key);
  final DataBaseProvider dataBase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Entries'),
        ),
        body: StreamBuilder<List<Entry>>(
            stream: dataBase.getEntries(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.length > 0) {
                final allEntites = snapshot.data.toList();
                final allEntriesRate = allEntites.map((e) => e.entryRate);
                final allEntrieHrs =
                    allEntites.map((e) => (e.end.difference(e.start).inHours));
                return Container(
                    child: Column(children: [
                  Container(
                    color: Colors.grey[400],
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 5, 15, 5),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'All Entries',
                              style: TextStyle(fontSize: 18),
                            ),
                            Row(
                              children: [
                                Text(
                                  '\$ ${allEntriesRate.reduce((a, b) => a + b).toString()}',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.green[400]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 25.0),
                                  child: Text(
                                    '${allEntrieHrs.reduce((a, b) => a + b).toString()} hr',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (ctx, index) {
                        return Divider();
                      },
                      itemCount: allEntites.length,
                      itemBuilder: (ctx, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 5, 15, 5),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 200,
                                  child: Text(
                                    allEntites[index].comment,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '\$ ${allEntites[index].entryRate.toString()}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.green[400]),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 25.0),
                                      child: Text(
                                        '${(allEntites[index].end.difference(allEntites[index].start)).inHours.toString()} hr',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]));
              }
              return Nojobs(
                  mainText: 'Nothing here',
                  subText: 'Add a new Entry to get started');
            }));
  }
}
