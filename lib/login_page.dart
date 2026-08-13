import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'register_dialog.dart';
import '../services/cloudbase_service.dart';

/// 登录对话框（小窗口）
class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final result = await CloudBaseService().login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (result['success'] == true) {
        final user = await CloudBaseService().getCurrentUser();
        Navigator.pop(context, user?['username'] ?? user?['email']);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('登录成功！')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'] ?? '登录失败')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 强制使用亮色主题，确保文字清晰
    return Theme(
      data: ThemeData.dark(),
      child: AlertDialog(
        title: Row(
          children: [
            Icon(
              CupertinoIcons.doc_text,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text('登录'),
          ],
        ),
        content: SizedBox(
          width: 320, // 固定宽度，控制对话框大小
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: '电子邮箱',
                    prefixIcon: Icon(CupertinoIcons.mail),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return '请输入邮箱';
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return '请输入有效的邮箱地址';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: '密码',
                    prefixIcon: const Icon(CupertinoIcons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? CupertinoIcons.eye
                            : CupertinoIcons.eye_slash,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return '请输入密码';
                    if (value.length < 6) return '密码至少6位';
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('取消'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('登录'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('还没有账号？'),
                    TextButton(
                      onPressed: () async {
                        // 弹出注册对话框
                        final result = await showDialog<String>(
                          context: context,
                          barrierDismissible: true,
                          builder: (ctx) => const RegisterDialog(),
                        );
                        if (result != null) {
                          // 注册成功，自动填充登录表单（可选）
                          // 例如：_emailController.text = result; // 将用户名填到邮箱？实际可根据需要调整
                          // 这里我们只做提示，用户手动登录
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('用户 $result 注册成功，请登录')),
                          );
                        }
                      },
                      child: const Text('立即注册'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: const [], // 已使用 content 内的按钮，此处留空
      ),
    );
  }
}
