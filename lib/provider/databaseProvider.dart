import 'package:flutter/material.dart';
import 'package:time_tracker/models/job.dart';
import 'package:time_tracker/repositories/database_repo.dart';

class DataBaseProvider extends ChangeNotifier {
  final DataBaseRepository _dataBaseRepository = DataBaseRepository();

  final String uid;
  List<Job> jobs = [];
  DataBaseProvider({@required this.uid, jobs}) {
    readJobs();
  }

  Future<void> readJobs() async {
    _dataBaseRepository
        .readJobs(this.uid)
        .then((value) => {jobs = value, notifyListeners()});
  }

  Future<void> createJob(jobdata) async {
    await _dataBaseRepository.createJob(jobdata, this.uid);
    readJobs();
  }

  Stream<List<Job>> getAllJobs() {
    return _dataBaseRepository.getAllJobs();
  }

  Future<void> getJob(documentUniquId) async {
    _dataBaseRepository.getJob(documentUniquId).then((value) => readJobs());
  }

  Future<void> editJob(documentUniquId, jobdata) async {
    _dataBaseRepository
        .editJob(documentUniquId, jobdata)
        .then((value) => readJobs());
  }
}
