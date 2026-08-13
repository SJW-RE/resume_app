// lib/services/cloud_data_service.dart
import '../models/resume.dart';
import 'data_service.dart';

/// 云端数据服务（未来实现）
class CloudDataService implements IDataService {
  @override
  Future<List<Resume>> fetchAllResumes() async {
    // TODO: 实现云端 API 调用
    throw UnimplementedError('云端同步功能开发中');
  }

  @override
  Future<Resume?> fetchResumeById(String id) async {
    throw UnimplementedError('云端同步功能开发中');
  }

  @override
  Future<void> saveResume(Resume resume) async {
    throw UnimplementedError('云端同步功能开发中');
  }

  @override
  Future<void> deleteResume(String id) async {
    throw UnimplementedError('云端同步功能开发中');
  }

  @override
  Future<void> clearAll() async {
    throw UnimplementedError('云端同步功能开发中');
  }
}