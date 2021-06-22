import 'package:time_tracker/models/entry.dart';
import 'package:time_tracker/models/job.dart';
import 'package:time_tracker/services/database.dart';

class DataBaseRepository {
  final FirebaseDataBase _firebaseDataBase = FirebaseDataBase();

  Future<List<Job>> readJobs(uid) {
    return _firebaseDataBase.readJobs(uid);
  }

  Future<void> createJob(JobData jobdata, uid) async {
    return _firebaseDataBase.createJob(jobdata, uid);
  }

  Stream<List<Job>> getAllJobs() {
    return _firebaseDataBase.getAllJobs();
  }

  Stream<List<Job>> getSingleJob(documentUniquId) {
    return _firebaseDataBase.getSingleJob(documentUniquId);
  }

  Future<void> deleteJob(documentUniquId) {
    return _firebaseDataBase.deleteJob(documentUniquId);
  }

  Future<void> editJob(documentUniquId, jobdata) {
    return _firebaseDataBase.editJob(documentUniquId, jobdata);
  }

  Stream<List<Entry>> getEntries({jobId, query, descend, uid}) {
    return _firebaseDataBase.getEntries(
        jobId: jobId, query: query, descend: descend, uid: uid);
  }

  Future<void> createEntry(Entry entry, uid) {
    return _firebaseDataBase.createEntry(entry, uid);
  }

  Future<void> deleteEntry(entryId) {
    return _firebaseDataBase.deleteEntry(entryId);
  }
}
