// lib/pages/payment_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../services/member_service.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isProcessing = false;
  bool _isSuccess = false;
  String _errorMessage = '';
  String _selectedPaymentMethod = 'alipay'; // 默认支付宝

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = '';
    });

    // 模拟支付延迟（接入真实 SDK 时替换）
    await Future.delayed(const Duration(seconds: 2));

    // 模拟支付结果（95% 成功率，模拟真实场景）
    final random = DateTime.now().millisecondsSinceEpoch % 100;
    if (random < 95) {
      // 支付成功，调用 CloudBase 更新会员状态
      final success = await MemberService.upgradeToPremium(months: 1);
      if (success) {
        setState(() {
          _isProcessing = false;
          _isSuccess = true;
        });
        // 延迟返回会员中心
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pop(context, true);
          }
        });
        return;
      } else {
        setState(() {
          _isProcessing = false;
          _errorMessage = '升级会员失败，请稍后重试';
        });
        return;
      }
    } else {
      // 模拟支付失败（5% 概率）
      setState(() {
        _isProcessing = false;
        _errorMessage = '支付失败，请检查网络后重试';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAlipay = _selectedPaymentMethod == 'alipay';
    final price = '¥9.90';

    return Scaffold(
      appBar: AppBar(
        title: const Text('确认支付'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 订单信息卡片
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '订单详情',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 24),
                    _buildOrderRow('商品', '会员月卡'),
                    _buildOrderRow('价格', price),
                    _buildOrderRow('有效期', '30 天'),
                    const Divider(height: 24),
                    _buildOrderRow('实付金额', price, isTotal: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 支付方式选择
            const Text(
              '支付方式',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPaymentMethod(
              icon: Icons.credit_card,
              title: '支付宝',
              subtitle: '推荐使用',
              method: 'alipay',
              isSelected: _selectedPaymentMethod == 'alipay',
              onTap: () {
                setState(() {
                  _selectedPaymentMethod = 'alipay';
                });
              },
            ),
            const SizedBox(height: 8),
            _buildPaymentMethod(
              icon: Icons.credit_card,
              title: '微信支付',
              subtitle: '支持零钱',
              method: 'wechat',
              isSelected: _selectedPaymentMethod == 'wechat',
              onTap: () {
                setState(() {
                  _selectedPaymentMethod = 'wechat';
                });
              },
            ),
            const SizedBox(height: 24),

            // 错误信息
            if (_errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const Spacer(),

            // 支付按钮（文案根据支付方式变化）
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isProcessing || _isSuccess ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('支付中...'),
                        ],
                      )
                    : _isSuccess
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, size: 24),
                          SizedBox(width: 8),
                          Text('支付成功'),
                        ],
                      )
                    : Text(
                        isAlipay ? '确认支付 $price (支付宝)' : '确认支付 $price (微信)',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '支付即表示同意《会员服务协议》',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod({
    required IconData icon,
    required String title,
    required String subtitle,
    required String method,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.green.shade50 : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.grey.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
          ],
        ),
      ),
    );
  }
}
