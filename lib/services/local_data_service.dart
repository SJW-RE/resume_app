// lib/services/local_data_service.dart
import '../models/resume.dart';
import 'resume_storage.dart';
import 'data_service.dart';

/// 本地数据服务实现（基于 Hive）
class LocalDataService implements IDataService {
  @override
  Future<List<Resume>> fetchAllResumes() async {
    // 模拟微延迟（更接近真实场景）
    await Future.delayed(const Duration(milliseconds: 100));
    return ResumeStorage.getAllResumes();
  }

  @override
  Future<Resume?> fetchResumeById(String id) async {
    await Future.delayed(const Duration(milliseconds: 80));
    return ResumeStorage.getResume(id);
  }

  @override
  Future<void> saveResume(Resume resume) async {
    await Future.delayed(const Duration(milliseconds: 150));
    await ResumeStorage.saveResume(resume);
  }

  @override
  Future<void> deleteResume(String id) async {
    await Future.delayed(const Duration(milliseconds: 120));
    await ResumeStorage.deleteResume(id);
  }

  @override
  Future<void> clearAll() async {
    await Future.delayed(const Duration(milliseconds: 100));
    await ResumeStorage.clearAll();
  }
}