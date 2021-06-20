import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker/components/widgets/dialogs.dart';
import 'package:time_tracker/models/job.dart';
import 'package:time_tracker/provider/databaseProvider.dart';

class AddJob extends StatefulWidget {
  const AddJob(
      {Key key,
      @required this.dataBase,
      this.jobName,
      this.jobRate,
      this.jobID,
      this.edit = false})
      : super(key: key);
  final DataBaseProvider dataBase;
  final String jobName;
  final int jobRate;
  final bool edit;
  final String jobID;
  @override
  _AddJob createState() => _AddJob();
}

class _AddJob extends State<AddJob> {
  TextEditingController jobNameController = TextEditingController();
  TextEditingController jobrateController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    jobrateController.dispose();
    jobNameController.dispose();
  }

  @override
  void initState() {
    super.initState();
    jobNameController.text = (widget.jobName != null) ? widget.jobName : '';
    jobrateController.text = (widget.jobRate != null)
        ? widget.jobRate.toString()
        : jobrateController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar:
            AppBar(title: Text(widget.edit ? 'Edit Job' : 'New Job'), actions: [
          // ignore: deprecated_member_use
          FlatButton(
              disabledTextColor: Colors.grey,
              textColor: Colors.white,
              onPressed: (jobNameController.text.isNotEmpty &&
                      jobrateController.text.isNotEmpty)
                  ? () async {
                      final alljobs = await widget.dataBase.getAllJobs().first;
                      final allNames =
                          alljobs.map((e) => e.jobData.name).toList();
                      if (widget.edit) {
                        allNames.remove(widget.jobName);
                      }
                      if (allNames
                          .contains(jobNameController.text.toString())) {
                        customDialogs(context, 'Name already exists',
                            'Please choose another Job name', 'Ok', false);
                      } else {
                        (widget.edit)
                            ? await widget.dataBase.editJob(
                                widget.jobID,
                                JobData(
                                  name: jobNameController.text.toString(),
                                  ratePerHour: int.parse(
                                      jobrateController.text.toString()),
                                ))
                            : await widget.dataBase.createJob(JobData(
                                name: jobNameController.text.toString(),
                                ratePerHour: int.parse(
                                    jobrateController.text.toString()),
                              ));
                        Navigator.pop(context);
                      }
                    }
                  : null,
              child: Text('save',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        ]),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: jobNameController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: 'Job name'),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: jobrateController,
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: false, signed: false),
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(labelText: 'Rate Per Hour'),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
            ),
          ),
        ));
  }
}
