import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/models/job.dart';

abstract class DataBase {
  Future<List<Job>> readJobs(uid);
  Future<void> createJob(JobData jobdata, uid);
  Stream<List<Job>> getAllJobs();
  Future<void> getJob(documentUniquId);
  Future<void> editJob(documentUniquId, jobdata);
  Stream<List<Job>> getSingleJob(documentUniquId);
}

class FirebaseDataBase implements DataBase {
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

  Future<void> getJob(documentUniquId) async {
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
            }));
  }
}
