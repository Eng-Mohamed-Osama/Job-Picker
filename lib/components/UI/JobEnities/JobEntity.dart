import 'package:flutter/material.dart';
import 'package:time_tracker/components/UI/homePage/addJob.dart';
import 'package:time_tracker/provider/databaseProvider.dart';

class JobEntity extends StatelessWidget {
  const JobEntity({
    Key key,
    @required this.dataBase,
    this.jobName,
    this.jobRate,
    this.jobID,
  }) : super(key: key);
  final DataBaseProvider dataBase;
  final String jobName;
  final int jobRate;
  final String jobID;

  @override
  Widget build(BuildContext context) {
    dataBase.readJobs();
    return StreamBuilder(
      stream: dataBase.getSingleJob(jobID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final job = snapshot.data;
          final jobname = job[0].jobData.name;
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
                                jobName: jobName,
                                jobRate: jobRate,
                                edit: true,
                                jobID: jobID,
                              )));
                },
                child: Text('Edit',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              )
            ]),
            body: Container(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
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
