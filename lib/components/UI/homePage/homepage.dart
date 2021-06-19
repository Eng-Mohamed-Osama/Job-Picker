import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/components/UI/JobEnities/JobEntity.dart';
import 'package:time_tracker/components/UI/homePage/addJob.dart';
import 'package:time_tracker/components/widgets/dialogs.dart';
import 'package:time_tracker/components/widgets/jobWidget.dart';
import 'package:time_tracker/components/widgets/noJobs.dart';
import 'package:time_tracker/provider/databaseProvider.dart';
import 'package:time_tracker/services/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.jobsProvider}) : super(key: key);
  final DataBaseProvider jobsProvider;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  void _logout(context) {
    final auth = Provider.of<Auth>(context, listen: false);
    auth.signout();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Jobs'), actions: [
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
                  child: Icon(Icons.logout, size: 18, color: Colors.white),
                )
              ],
            ))
      ]),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 16, bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(5)),
                height: 35,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.search,
                        size: 17,
                      ),
                      hintText: 'search',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) async {
                      widget.jobsProvider.readJobs();
                    },
                  ),
                ),
              ),
            ),
            (widget.jobsProvider.jobs != null &&
                    widget.jobsProvider.jobs
                            .where((element) => element.jobData.name
                                .contains(searchController.text))
                            .toList()
                            .length >
                        0)
                ? Expanded(
                    child: ListView.separated(
                        separatorBuilder: (ctx, index) {
                          return Divider(
                            height: .5,
                            color: Colors.black12,
                          );
                        },
                        itemCount: widget.jobsProvider.jobs
                            .where((element) => element.jobData.name
                                .contains(searchController.text))
                            .toList()
                            .length,
                        itemBuilder: (ctx, index) {
                          final job = widget.jobsProvider.jobs
                              .where((element) => element.jobData.name
                                  .contains(searchController.text))
                              .toList()[index];
                          return JobWidget(
                            title: job.jobData.name,
                            index: index,
                            id: job.docId,
                            provider: widget.jobsProvider,
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => JobEntity(
                                            dataBase: widget.jobsProvider,
                                            jobName: job.jobData.name,
                                            jobRate: job.jobData.ratePerHour,
                                            jobID: job.docId,
                                          )))
                            },
                          );
                        }),
                  )
                : Expanded(
                    child: Nojobs(
                        mainText: 'Nothing here',
                        subText: (searchController.text.isEmpty)
                            ? 'Add a new item to get started'
                            : 'No Job Match Your Search'),
                  )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final data = Provider.of<DataBaseProvider>(context, listen: false);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddJob(
                        dataBase: data,
                      )));
        },
      ),
    );
  }
}
