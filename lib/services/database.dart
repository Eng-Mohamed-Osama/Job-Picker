import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/models/entry.dart';
import 'package:time_tracker/models/job.dart';

abstract class DataBase {
  Future<List<Job>> readJobs(uid);
  Future<void> createJob(JobData jobdata, uid);
  Stream<List<Job>> getAllJobs();
  Future<void> deleteJob(documentUniquId);
  Future<void> editJob(documentUniquId, jobdata);
  Stream<List<Job>> getSingleJob(documentUniquId);
  Future<void> createEntry(Entry entry, uid);
  Future<void> deleteEntry(entryId);
  Stream<List<Entry>> getEntries({jobId, query, descend, uid});
}

class FirebaseDataBase implements DataBase {
  //Jobs

  Future<List<Job>> readJobs(uid) async {
    final List<Job> jobs = [];

    final snapshot = await FirebaseFirestore.instance
        .collection('Jobs')
        .where('userId', isEqualTo: uid)
        .get();
    snapshot.docs.forEach((element) {
      Job job = Job.fromJson(element.data());
      jobs.add(job);
    });

    return jobs;
  }

  Stream<List<Job>> getAllJobs() {
    final snapshots = FirebaseFirestore.instance.collection('Jobs').snapshots();
    return snapshots.map((snapshot) => snapshot.docs.map((e) {
          final data = e.data();
          return data != null ? Job.fromJson(data) : null;
        }).toList());
  }

  Stream<List<Job>> getSingleJob(documentUniquId) {
    final snapshots = FirebaseFirestore.instance
        .collection('Jobs')
        .where('docId', isEqualTo: documentUniquId)
        .snapshots();
    return snapshots.map((snapshot) => snapshot.docs.map((e) {
          final data = e.data();
          return data != null ? Job.fromJson(data) : null;
        }).toList());
  }

  Future<void> createJob(JobData jobdata, uid) async {
    var documentUniquId = DateTime.now().toIso8601String();
    await FirebaseFirestore.instance.collection('Jobs').doc().set({
      'docId': documentUniquId,
      'userId': uid,
      'jobData': jobdata.toJson(),
    });
  }

  Future<void> deleteJob(documentUniquId) async {
    await FirebaseFirestore.instance
        .collection('Jobs')
        .where('docId', isEqualTo: documentUniquId)
        .get()
        .then((value) => value.docs.forEach((element) => {
              FirebaseFirestore.instance
                  .collection('Jobs')
                  .doc(element.id)
                  .delete()
            }));
    FirebaseFirestore.instance
        .collection('Entries')
        .where('jobId', isEqualTo: documentUniquId)
        .get()
        .then((value) => value.docs.forEach((element) => {
              FirebaseFirestore.instance
                  .collection('Entries')
                  .doc(element.id)
                  .delete()
            }));
  }

  Future<void> editJob(documentUniquId, jobdata) async {
    await FirebaseFirestore.instance
        .collection('Jobs')
        .where('docId', isEqualTo: documentUniquId)
        .get()
        .then((value) => value.docs.forEach((element) => {
              FirebaseFirestore.instance
                  .collection('Jobs')
                  .doc(element.id)
                  .update({
                'jobData': jobdata.toJson(),
              })
            }))
        .then((_) => FirebaseFirestore.instance
            .collection('Entries')
            .where('jobId', isEqualTo: documentUniquId)
            .get()
            .then((value) => value.docs.forEach((e) => {
                  FirebaseFirestore.instance
                      .collection('Entries')
                      .doc(e.id)
                      .update({
                    'entryRate': jobdata.ratePerHour *
                        (FirebaseFirestore.instance
                            .collection('Entries')
                            .doc(e.id)
                            .snapshots()
                            .map((event) => event
                                .data()
                                .values
                                .elementAt(1)
                                .toDate()
                                .difference(FirebaseFirestore.instance
                                    .collection('Entries')
                                    .doc(e.id)
                                    .snapshots()
                                    .map((event) => event
                                        .data()
                                        .values
                                        .elementAt(5)
                                        .toDate()))
                                .inHours)),
                  })
                })));
  }

  //Entries

  Stream<List<Entry>> getEntries({jobId, query, descend, uid}) {
    print('we are here $descend');
    final snapshots = (jobId != null)
        ? FirebaseFirestore.instance
            .collection('Entries')
            .where('jobId', isEqualTo: jobId)
            .snapshots()
        : FirebaseFirestore.instance
            .collection('Entries')
            .where('userId', isEqualTo: uid)
            .orderBy(query, descending: descend)
            .snapshots();
    return snapshots.map((snapshot) => snapshot.docs.map((e) {
          final data = e.data();
          return data != null ? Entry.fromJson(data) : null;
        }).toList());
  }

  Future<void> createEntry(Entry entry, uid) async {
    await FirebaseFirestore.instance.collection('Entries').doc().set({
      'comment': entry.comment,
      'start': entry.start,
      'end': entry.end,
      'jobId': entry.jobId,
      'userId': uid,
      'entryRate': entry.entryRate,
      'id': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> deleteEntry(entryId) async {
    await FirebaseFirestore.instance
        .collection('Entries')
        .where('id', isEqualTo: entryId)
        .get()
        .then((value) => value.docs.forEach((element) => {
              FirebaseFirestore.instance
                  .collection('Entries')
                  .doc(element.id)
                  .delete()
            }));
  }
}
