// lib/services/data_service.dart
import '../models/resume.dart';

abstract class IDataService {
  Future<List<Resume>> fetchAllResumes();
  Future<Resume?> fetchResumeById(String id);
  Future<void> saveResume(Resume resume);
  Future<void> deleteResume(String id);
  Future<void> clearAll();
}