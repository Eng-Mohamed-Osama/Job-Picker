import 'package:flutter/material.dart';
import 'package:time_tracker/models/entry.dart';
import 'package:time_tracker/models/job.dart';
import 'package:time_tracker/repositories/database_repo.dart';

class DataBaseProvider extends ChangeNotifier {
  final DataBaseRepository _dataBaseRepository = DataBaseRepository();

  final String uid;
  List<Job> jobs = [];
  DataBaseProvider({@required this.uid}) {
    readJobs();
  }

  //Jobs

  Future<void> readJobs() async {
    await _dataBaseRepository
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

  Stream<List<Job>> getSingleJob(documentUniquId) {
    return _dataBaseRepository.getSingleJob(documentUniquId);
  }

  Future<void> deleteJob(documentUniquId) async {
    _dataBaseRepository.deleteJob(documentUniquId).then((value) => readJobs());
  }

  Future<void> editJob(documentUniquId, jobdata) async {
    _dataBaseRepository
        .editJob(documentUniquId, jobdata)
        .then((value) => readJobs());
  }

  //Entries

  Stream<List<Entry>> getEntries({jobId}) {
    return _dataBaseRepository.getEntries(jobId: jobId);
  }

  Future<void> createEntry(Entry entry) async {
    await _dataBaseRepository.createEntry(entry);
  }

  Future<void> deleteEntry(entryId) async {
    await _dataBaseRepository.deleteEntry(entryId);
  }
}
