import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../services/member_service.dart';
import '../models/member.dart';
import '../services/cloudbase_service.dart';
import '../payment_page.dart';

class MemberCenterPage extends StatefulWidget {
  const MemberCenterPage({super.key});

  @override
  State<MemberCenterPage> createState() => _MemberCenterPageState();
}

class _MemberCenterPageState extends State<MemberCenterPage> {
  Member? _member;
  bool _isLoading = true;
  bool _isProcessing = false;

  // 会员权益文案
  List<String> get _freeBenefits => [
        '📄 1 套免费模板',
        '💧 PDF 导出带水印',
        '🔢 每日导出 3 次',
        '💾 10MB 云存储空间',
      ];

  List<String> get _memberBenefits => [
        '📄 4 套全部模板',
        '✨ PDF 无水印导出',
        '♾️ 导出次数无限制',
        '💾 100MB 云存储空间',
        '👨‍💻 专属客服支持',
      ];

  @override
  void initState() {
    super.initState();
    _loadMemberStatus();
  }

  Future<void> _loadMemberStatus() async {
    setState(() => _isLoading = true);
    final member = await MemberService.getMemberInfo();
    setState(() {
      _member = member;
      _isLoading = false;
    });
  }

 // 在 _MemberCenterPageState 中替换 _upgradeMember 方法
Future<void> _upgradeMember() async {
  // 跳转到支付页面，等待支付结果
  final result = await Navigator.push<bool>(
    context,
    MaterialPageRoute(builder: (context) => const PaymentPage()),
  );

  if (result == true) {
    // 支付成功，刷新会员信息
    await _loadMemberStatus();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 升级成功！已解锁全部权益')),
      );
    }
  } else if (result == false) {
    // 用户主动取消支付
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('支付已取消')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final isMember = _member?.isPremium ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('会员中心')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 会员状态卡片
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                isMember ? Icons.star : Icons.star_border,
                                color: isMember ? Colors.amber : Colors.grey,
                                size: 40,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  isMember ? '🎉 会员用户' : '👤 免费用户',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            isMember
                                ? '您已解锁全部 5 项会员权益'
                                : '升级会员，解锁更多专属功能',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (!isMember)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isProcessing ? null : _upgradeMember,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                child: _isProcessing
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.black,
                                        ),
                                      )
                                    : const Text(
                                        '立即升级 · ¥9.9/月',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          if (isMember && _member?.expireAt != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                '会员有效期至：${_formatDate(_member!.expireAt!)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 权益列表
                  const Text(
                    '当前权益',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  ...(isMember ? _memberBenefits : _freeBenefits).map(
                    (benefit) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Icon(
                            isMember ? Icons.check_circle : Icons.circle,
                            color: isMember ? Colors.green : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            benefit,
                            style: TextStyle(
                              fontSize: 16,
                              color: isMember ? Colors.black : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (!isMember) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.blue),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '升级会员后可解锁全部 4 套模板和无水印导出',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    '会员权益最终解释权归本应用所有',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}