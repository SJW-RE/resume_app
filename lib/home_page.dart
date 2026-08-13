import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import '../services/resume_storage.dart';
import '../models/resume.dart';
import '../models/personal_info.dart';
import 'profile_page.dart';
import 'services/loading_service.dart';
import '../services/local_data_service.dart';
import '../services/data_service.dart';

class ResumeListPage extends StatefulWidget {
  const ResumeListPage({super.key});

  @override
  _ResumeListPageState createState() => _ResumeListPageState();
}

class _ResumeListPageState extends State<ResumeListPage> {
  List<Resume> _resumes = [];
  bool _isLoading = true; // 新增

  @override
  void initState() {
    super.initState();
    _loadResumes();
  }

  // 在 _ResumeListPageState 中添加数据服务实例
  final IDataService _dataService = LocalDataService();

  void _loadResumes() async {
    setState(() => _isLoading = true);

    try {
      // 使用 Future.wait 并行加载（目前只有一个数据源，未来可扩展）
      final results = await Future.wait([
        _dataService.fetchAllResumes(),
        // 未来可添加：_cloudService.fetchAllResumes(),
      ]);

      // 取第一个结果（本地数据）
      final localResumes = results[0];

      setState(() {
        _resumes = localResumes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _resumes = [];
        _isLoading = false;
      });
      // 可添加错误处理，如显示 SnackBar
      debugPrint('加载简历失败: $e');
    }
  }

  void _addNewResume() {
    // 创建一个空的简历，跳转到编辑器
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final emptyResume = Resume(
      id: newId,
      name: '未命名简历',
      updatedAt: DateTime.now(),
      personal: PersonalInfo(fullName: '', jobTitle: '', phone: '', email: ''),
      workExperiences: [],
      educations: [],
      skills: [],
      projects: [],
      summary: '',
    );
    context.push('/editor', extra: emptyResume);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('我的简历')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // ✅ 加载中显示动画
          : _resumes.isEmpty
          ? Center(child: Text('暂无简历，点击右下角＋创建'))
          : ListView.builder(
              itemCount: _resumes.length,
              itemBuilder: (context, index) {
                final resume = _resumes[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(resume.name),
                    subtitle: Text('最后更新：${resume.updatedAt.toLocal()}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(CupertinoIcons.pencil),
                          onPressed: () {
                            context.push('/editor', extra: resume);
                          },
                        ),
                        IconButton(
                          icon: Icon(CupertinoIcons.delete),
                          onPressed: () async {
                            LoadingService.show(context, message: '删除中...');
                            try {
                              await ResumeStorage.deleteResume(resume.id);
                              LoadingService.hide();
                              _loadResumes(); // 刷新列表
                            } catch (e) {
                              LoadingService.hide();
                              // 错误处理
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewResume,
        child: Icon(CupertinoIcons.add),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [ResumeListPage(), ProfilePage()];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.doc_text),
            label: '简历',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}
