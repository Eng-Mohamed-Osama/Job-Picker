import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:time_tracker/components/widgets/noJobs.dart';
import 'package:time_tracker/models/entry.dart';
import 'package:time_tracker/provider/databaseProvider.dart';

class AllEntries extends StatefulWidget {
  const AllEntries({Key key, this.dataBase}) : super(key: key);
  final DataBaseProvider dataBase;

  @override
  _AllEntriesState createState() => _AllEntriesState();
}

class _AllEntriesState extends State<AllEntries> {
  String query = 'comment';
  bool descend = false;

  @override
  void initState() {
    super.initState();
    descend = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Entries'),
        ),
        body: StreamBuilder<List<Entry>>(
            stream: widget.dataBase.getEntries(query: query, descend: descend),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.length > 0) {
                final allEntites = snapshot.data.toList();
                final allEntriesRate = allEntites.map((e) => e.entryRate);
                final allEntrieHrs =
                    allEntites.map((e) => (e.end.difference(e.start).inHours));
                return Container(
                    child: Column(children: [
                  Container(
                    color: Colors.grey[350],
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 15, 15, 15),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'All Entries',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Icon(
                                      (descend)
                                          ? Icons.arrow_downward_rounded
                                          : Icons.arrow_upward_outlined,
                                      size: 16,
                                    )
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    query = 'comment';
                                    descend = !descend;
                                  });
                                }),
                            Row(
                              children: [
                                GestureDetector(
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                            '\$ ${allEntriesRate.reduce((a, b) => a + b).toString()}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.green[400])),
                                        Icon(
                                          (descend)
                                              ? Icons.arrow_downward_rounded
                                              : Icons.arrow_upward_outlined,
                                          size: 16,
                                        )
                                      ]),
                                  onTap: () {
                                    setState(() {
                                      query = 'entryRate';
                                      descend = !descend;
                                    });
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
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
                                  width: 180,
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
                                      padding: const EdgeInsets.only(
                                          left: 30.0, right: 0),
                                      child: Text(
                                        '${(allEntites[index].end.difference(allEntites[index].start)).inHours.toString()} hr',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
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
