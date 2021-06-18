// To parse this JSON data, do
//
//     final job = jobFromJson(jsonString);

import 'dart:convert';

Job jobFromJson(String str) => Job.fromJson(json.decode(str));

String jobToJson(Job data) => json.encode(data.toJson());

class Job {
  Job({
    this.jobData,
    this.userId,
    this.docId,
  });

  JobData jobData;
  String userId;
  String docId;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        jobData: JobData.fromJson(json["jobData"]),
        userId: json["userId"],
        docId: json["docId"],
      );

  Map<String, dynamic> toJson() => {
        "jobData": jobData.toJson(),
        "userId": userId,
        "docId": docId,
      };
}

class JobData {
  JobData({
    this.name,
    this.ratePerHour,
  });

  String name;
  int ratePerHour;

  factory JobData.fromJson(Map<String, dynamic> json) => JobData(
        name: json["name"],
        ratePerHour: json["ratePerHour"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "ratePerHour": ratePerHour,
      };
}
