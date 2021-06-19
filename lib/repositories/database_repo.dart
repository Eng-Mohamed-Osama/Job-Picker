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

  Future<void> getJob(documentUniquId) {
    return _firebaseDataBase.getJob(documentUniquId);
  }

  Future<void> editJob(documentUniquId, jobdata) {
    return _firebaseDataBase.editJob(documentUniquId, jobdata);
  }
}
