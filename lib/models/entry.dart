// To parse this JSON data, do
//
//     final entry = entryFromJson(jsonString);

import 'dart:convert';

Entry entryFromJson(String str) => Entry.fromJson(json.decode(str));

String entryToJson(Entry data) => json.encode(data.toJson());

class Entry {
  Entry({
    this.comment,
    this.start,
    this.end,
    this.jobId,
    this.id,
    this.entryRate,
  });

  String comment;
  DateTime start;
  DateTime end;
  String jobId;
  int id;
  int entryRate;

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
        comment: json["comment"],
        end: json["end"].toDate(),
        id: json["id"],
        start: json["start"].toDate(),
        jobId: json["jobId"],
        entryRate: json["entryRate"],
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "start": start,
        "end": end,
        "jobId": jobId,
        "entryRate": entryRate,
        "id": id,
      };
}
