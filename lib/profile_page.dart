import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../services/resume_storage.dart';
import 'login_page.dart';
import '../services/data_service.dart';
import '../services/local_data_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../services/cloudbase_service.dart';
import '../member_center_page.dart';
import '../settings_page.dart';
import '../privacy_policy_page.dart';
import '../feedback_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _resumeCount = 0;
  String _currentTheme = 'dark';
  String? _username;
  String? _email;
  bool _isLoggedIn = false;
  bool _isLoading = true;
  final IDataService _dataService = LocalDataService();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadStats() async {
    try {
      final results = await Future.wait([_dataService.fetchAllResumes()]);
      final localResumes = results[0];
      if (mounted) {
        setState(() {
          _resumeCount = localResumes.length;
        });
      }
    } catch (e) {
      print('加载统计数据失败: $e');
      if (mounted) {
        setState(() {
          _resumeCount = 0;
        });
      }
    }
  }

  String _getThemeLabel(String mode) {
    switch (mode) {
      case 'light':
        return '亮色';
      case 'dark':
        return '暗色';
      default:
        return '跟随系统';
    }
  }

  Future<void> _loadUserInfo() async {
    setState(() => _isLoading = true);
    final user = await CloudBaseService().getCurrentUser();
    setState(() {
      _username = user?['username'];
      _email = user?['email'];
      _isLoggedIn = user != null;
      _isLoading = false;
    });
  }

  Future<void> _showThemeDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('选择主题'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('跟随系统'),
              value: 'system',
              groupValue: _currentTheme,
              onChanged: (value) {
                if (value != null) Navigator.pop(ctx, value);
              },
            ),
            RadioListTile<String>(
              title: const Text('亮色模式'),
              value: 'light',
              groupValue: _currentTheme,
              onChanged: (value) {
                if (value != null) Navigator.pop(ctx, value);
              },
            ),
            RadioListTile<String>(
              title: const Text('暗色模式'),
              value: 'dark',
              groupValue: _currentTheme,
              onChanged: (value) {
                if (value != null) Navigator.pop(ctx, value);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
        ],
      ),
    );
    if (result != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('themeMode', result);
      themeNotifier.value = result;
      setState(() {
        _currentTheme = result;
      });
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('退出'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await CloudBaseService().logout();
      _loadUserInfo();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('已退出登录')));
    }
  }

  Future<void> _showEditProfileDialog() async {
    if (!_isLoggedIn) return;
    final nameController = TextEditingController(text: _username ?? '');

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('编辑资料'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '显示名称',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Text('邮箱：$_email', style: const TextStyle(color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              if (newName.isEmpty) {
                ScaffoldMessenger.of(
                  ctx,
                ).showSnackBar(const SnackBar(content: Text('名称不能为空')));
                return;
              }
              await CloudBaseService().updateUserInfo(username: newName);
              Navigator.pop(ctx, true);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (result == true) {
      await _loadUserInfo();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('资料已更新')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildHeader(),
                // ---- 统计卡片 ----
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            '简历总数',
                            '$_resumeCount',
                            Icons.description,
                          ),
                          _buildStatItem('草稿', '0', Icons.drafts),
                          _buildStatItem('已导出', '0', Icons.picture_as_pdf),
                        ],
                      ),
                    ),
                  ),
                ),

                // ---- 设置列表 ----
                const SizedBox(height: 8),

                ListTile(
                  leading: const Icon(CupertinoIcons.settings),
                  title: const Text('设置'),
                  trailing: const Icon(CupertinoIcons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
                //                ListTile(
                //                 leading: const Icon(CupertinoIcons.star),
                //                  title: const Text('会员中心'),
                //                  trailing: const Icon(CupertinoIcons.chevron_right),
                //                  onTap: () {
                //                    Navigator.push(
                //                      context,
                //                      MaterialPageRoute(
                //                        builder: (context) => const MemberCenterPage(),
                //                      ),
                //                    );
                //                  },
                //                ),
                ListTile(
                  leading: const Icon(CupertinoIcons.paintbrush),
                  title: const Text('主题模式'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_getThemeLabel(_currentTheme)),
                      const Icon(CupertinoIcons.chevron_right),
                    ],
                  ),
                  onTap: _showThemeDialog,
                ),
                ListTile(
                  leading: const Icon(CupertinoIcons.trash),
                  title: const Text('清空所有简历'),
                  trailing: const Icon(CupertinoIcons.chevron_right),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('确认清空'),
                        content: const Text('确定要删除所有简历吗？此操作不可撤销。'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('取消'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('清空'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await ResumeStorage.clearAll();
                      _loadStats();
                      setState(() {});
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('已清空所有简历')),
                        );
                      }
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(CupertinoIcons.info),
                  title: const Text('关于'),
                  trailing: const Icon(CupertinoIcons.chevron_right),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: '简历制作',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2025 个人开发',
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(
                    CupertinoIcons.square_arrow_left,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  title: const Text(
                    '退出登录',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  onTap: _logout,
                ),
                // 在“关于”下方添加
                ListTile(
                  leading: const Icon(CupertinoIcons.doc_text),
                  title: const Text('隐私政策与用户协议'),
                  trailing: const Icon(CupertinoIcons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(CupertinoIcons.mail),
                  title: const Text('意见反馈'),
                  trailing: const Icon(CupertinoIcons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FeedbackPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        children: [
          GestureDetector(
            onTap: _isLoggedIn ? _showEditProfileDialog : null,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(
                CupertinoIcons.person,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: _isLoggedIn ? _showEditProfileDialog : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isLoggedIn ? _username ?? '用户' : '未登录',
                    style:
                        (Theme.of(context).textTheme.titleMedium ?? TextStyle())
                            .copyWith(
                              fontWeight: FontWeight.w600,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                  ),
                  Text(
                    _isLoggedIn ? _email ?? '' : '请点击右侧登录',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (_isLoggedIn) {
                await CloudBaseService().logout();
                await _loadUserInfo();
              }
              final result = await showDialog<String>(
                context: context,
                barrierDismissible: true,
                builder: (ctx) => const LoginDialog(),
              );
              if (result != null) {
                await _loadUserInfo();
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: Text(_isLoggedIn ? '切换账号' : '登录/注册'),
          ),
          if (_isLoggedIn) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: _logout,
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade300),
              child: const Text('退出'),
            ),
          ],
        ],
      ),
    );
  }
}
