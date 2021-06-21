import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/components/widgets/dialogs.dart';
import 'package:time_tracker/models/entry.dart';
import 'package:time_tracker/provider/databaseProvider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddEntry extends StatefulWidget {
  const AddEntry({
    Key key,
    @required this.dataBase,
    this.jobRate,
    this.jobID,
  }) : super(key: key);
  final DataBaseProvider dataBase;
  final int jobRate;
  final String jobID;
  @override
  _AddEntry createState() => _AddEntry();
}

class _AddEntry extends State<AddEntry> {
  TextEditingController entryStartDateController = TextEditingController();
  TextEditingController entryEndDateController = TextEditingController();
  TextEditingController entryCommentController = TextEditingController();
  DateTime dateTime = DateTime.now();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  @override
  void dispose() {
    super.dispose();
    entryStartDateController.dispose();
    entryEndDateController.dispose();
    entryCommentController.dispose();
  }

  @override
  void initState() {
    entryStartDateController.text =
        DateFormat('yyyy-MM-dd – kk:mm').format(dateTime).toString();
    entryEndDateController.text =
        DateFormat('yyyy-MM-dd – kk:mm').format(dateTime).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(title: Text('New Entry'), actions: [
          // ignore: deprecated_member_use
          FlatButton(
              disabledTextColor: Colors.grey,
              textColor: Colors.white,
              onPressed: (entryStartDateController.text.isNotEmpty &&
                      entryEndDateController.text.isNotEmpty &&
                      entryCommentController.text.isNotEmpty)
                  ? () async {
                      if (endTime.isBefore(startTime)) {
                        customDialogs(
                            context,
                            'Error',
                            'Your entry end date can\'t be set to a date  before your entry start date Please fix this',
                            'Ok',
                            false);
                      } else {
                        await widget.dataBase.createEntry(Entry(
                          comment: entryCommentController.text.toString(),
                          start: startTime,
                          end: endTime,
                          entryRate: (endTime.difference(startTime).inHours) *
                              widget.jobRate,
                          jobId: widget.jobID,
                        ));
                        Navigator.pop(context);
                      }
                    }
                  : null,
              child: Text('Add Entry',
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
                        onTap: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              maxTime: DateTime(2022, 6, 7), onChanged: (date) {
                            entryStartDateController.text =
                                DateFormat('yyyy-MM-dd – kk:mm')
                                    .format(date)
                                    .toString();
                          }, onConfirm: (date) {
                            setState(() {
                              startTime = date;
                            });
                            entryStartDateController.text =
                                DateFormat('yyyy-MM-dd – kk:mm')
                                    .format(date)
                                    .toString();
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        showCursor: false,
                        readOnly: true,
                        controller: entryStartDateController,
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: false, signed: false),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: 'Start Date'),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: entryEndDateController,
                        onTap: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              maxTime: DateTime(2022, 6, 7), onConfirm: (date) {
                            setState(() {
                              endTime = date;
                            });
                            entryEndDateController.text =
                                DateFormat('yyyy-MM-dd – kk:mm')
                                    .format(date)
                                    .toString();
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        showCursor: false,
                        readOnly: true,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(labelText: 'End Date'),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        (entryEndDateController.text.isNotEmpty &&
                                entryStartDateController.text.isNotEmpty)
                            ? 'Duration :  ${endTime.difference(startTime).inHours} H'
                            : 'Duration : 0 H',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: entryCommentController,
                        maxLength: 50,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: 'Comment',
                        ),
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
