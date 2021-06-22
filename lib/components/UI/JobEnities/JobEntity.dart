import 'package:flutter/material.dart';
import 'package:time_tracker/components/UI/JobEnities/addEntryPage.dart';
import 'package:time_tracker/components/UI/JobEnities/entryWidget.dart';
import 'package:time_tracker/components/UI/homePage/addJob.dart';
import 'package:time_tracker/components/widgets/noJobs.dart';
import 'package:time_tracker/models/entry.dart';
import 'package:time_tracker/provider/databaseProvider.dart';

class JobEntity extends StatelessWidget {
  const JobEntity({
    Key key,
    @required this.dataBase,
    this.jobID,
  }) : super(key: key);
  final DataBaseProvider dataBase;

  final String jobID;

  @override
  Widget build(BuildContext context) {
    print(jobID);
    return StreamBuilder(
      stream: dataBase.getSingleJob(jobID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final job = snapshot.data;
          final jobname = job[0].jobData.name;
          final jobrate = job[0].jobData.ratePerHour;
          return Scaffold(
            appBar: AppBar(centerTitle: true, title: Text(jobname), actions: [
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddJob(
                                dataBase: dataBase,
                                jobName: jobname,
                                jobRate: jobrate,
                                edit: true,
                                jobID: jobID,
                              )));
                },
                child: Text('Edit',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              )
            ]),
            body: _bulidEntry(context, dataBase, jobID),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEntry(
                              dataBase: dataBase,
                              jobRate: jobrate,
                              jobID: jobID,
                            )));
              },
              child: Icon(Icons.add),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

Widget _bulidEntry(BuildContext context, DataBaseProvider dataBase, jobId) {
  return StreamBuilder<List<Entry>>(
      stream: dataBase.getEntries(jobId: jobId),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.length > 0) {
          final allEntites = snapshot.data.toList();
          return ListView.separated(
            separatorBuilder: (ctx, index) {
              return Divider();
            },
            itemCount: allEntites.length,
            itemBuilder: (ctx, index) {
              return EntryWidget(
                provider: dataBase,
                entry: allEntites[index],
              );
            },
          );
        }
        return Nojobs(
            mainText: 'Nothing here',
            subText: 'Add a new Entry to get started');
      });
}
