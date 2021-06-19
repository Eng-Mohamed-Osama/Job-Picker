import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/components/UI/JobEnities/JobEntity.dart';
import 'package:time_tracker/components/UI/homePage/addJob.dart';
import 'package:time_tracker/components/widgets/dialogs.dart';
import 'package:time_tracker/components/widgets/jobWidget.dart';
import 'package:time_tracker/components/widgets/noJobs.dart';
import 'package:time_tracker/provider/databaseProvider.dart';
import 'package:time_tracker/services/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  void _logout(context) {
    final auth = Provider.of<Auth>(context, listen: false);
    auth.signout();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1,
        child: Consumer<DataBaseProvider>(
            builder: (buildContext, jobsProvider, _) {
          return Scaffold(
            appBar: AppBar(title: Text('Jobs'), actions: [
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () async {
                    bool logout = await customDialogs(context, 'Log Out',
                        'Are you sure you want to log out?', 'Log Out', true);
                    if (logout) {
                      _logout(context);
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Logout',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child:
                            Icon(Icons.logout, size: 18, color: Colors.white),
                      )
                    ],
                  ))
            ]),
            body: (jobsProvider.jobs != null && jobsProvider.jobs.length > 0)
                ? ListView.separated(
                    separatorBuilder: (ctx, index) {
                      return Divider(
                        height: .5,
                        color: Colors.black12,
                      );
                    },
                    itemCount: jobsProvider.jobs.length,
                    itemBuilder: (ctx, index) {
                      final job = jobsProvider.jobs[index];
                      return JobWidget(
                        title: job.jobData.name,
                        index: index,
                        id: job.docId,
                        provider: jobsProvider,
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => JobEntity(
                                        dataBase: jobsProvider,
                                        jobName: job.jobData.name,
                                        jobRate: job.jobData.ratePerHour,
                                        jobID: job.docId,
                                      )))
                        },
                      );
                    })
                : Nojobs(),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                final data =
                    Provider.of<DataBaseProvider>(context, listen: false);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddJob(
                              dataBase: data,
                            )));
              },
            ),
          );
        }));
  }
}
