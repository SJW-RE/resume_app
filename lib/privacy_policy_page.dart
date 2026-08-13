// lib/pages/privacy_policy_page.dart
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('隐私政策与用户协议'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '隐私政策'),
              Tab(text: '用户协议'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [PrivacyPolicyContent(), TermsOfServiceContent()],
        ),
      ),
    );
  }
}

class PrivacyPolicyContent extends StatelessWidget {
  const PrivacyPolicyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            '隐私政策',
            '本应用尊重并保护所有用户的个人隐私。为了给您提供更准确、更个性化的服务，本应用将按照本隐私权政策的规定使用和披露您的个人信息。但本应用将以高度的勤勉、审慎义务对待这些信息。除本隐私权政策另有规定外，在未征得您事先许可的情况下，本应用不会将这些信息对外披露或向第三方提供。本应用会不时更新本隐私权政策。您在同意本应用服务使用协议之时，即视为您已经同意本隐私权政策全部内容。本隐私权政策属于本应用服务使用协议不可分割的一部分。',
          ),
          const SizedBox(height: 16),
          _buildSection(
            '1. 信息收集',
            '本应用收集您主动提供的个人信息，包括但不限于：姓名、联系方式、邮箱地址、简历内容等。这些信息仅用于为您提供简历编辑、导出和存储服务。',
          ),
          const SizedBox(height: 12),
          _buildSection(
            '2. 信息使用',
            'a) 本应用不会向任何无关第三方提供、出售、出租、分享或交易您的个人信息。\n'
                'b) 本应用仅在本应用内部使用您的个人信息，用于提供、维护和改进本应用的服务。\n'
                'c) 本应用不会将您的个人信息用于任何其他用途。',
          ),
          const SizedBox(height: 12),
          _buildSection(
            '3. 信息存储',
            '所有简历数据仅存储在您的设备本地（Hive 数据库），不会上传至任何云端服务器。您可以通过“导出备份”功能自行备份数据。卸载应用或清除数据会导致所有本地数据丢失，请提前做好备份。',
          ),
          const SizedBox(height: 12),
          _buildSection(
            '4. 信息安全',
            '本应用将采取合理的安全措施保护您的个人信息，防止数据丢失、滥用或篡改。但由于技术的限制以及可能存在的各种恶意手段，在互联网行业，即便竭尽所能加强安全措施，也不可能始终保证信息百分之百的安全。请您了解并理解，您使用本应用时，需自行承担信息泄露的风险。',
          ),
          const SizedBox(height: 12),
          _buildSection(
            '5. 未成年人保护',
            '我们鼓励父母或监护人指导未满十八周岁的未成年人使用本应用。本应用不会主动收集未成年人的个人信息，若您发现我们未经授权收集了未成年人的信息，请联系我们，我们将及时删除。',
          ),
          const SizedBox(height: 12),
          _buildSection(
            '6. 隐私政策的修改',
            '本应用可能适时修订本隐私政策，更新后的隐私政策将公布在本页面，请您定期查看。如您不同意修订后的隐私政策，您有权停止使用本应用。',
          ),
          const SizedBox(height: 12),
          _buildSection(
            '7. 联系我们',
            '如果您对本隐私政策有任何疑问、建议或投诉，请通过以下方式联系我们：\n'
                '邮箱：965697673@qq.com',
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Color.fromARGB(221, 255, 255, 255),
          ),
        ),
      ],
    );
  }
}

class TermsOfServiceContent extends StatelessWidget {
  const TermsOfServiceContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            '用户协议',
            '欢迎使用本应用。本协议是您与本应用运营方之间关于使用本应用及相关服务所订立的协议。请您仔细阅读本协议，您使用本应用即视为您已阅读并同意本协议的全部内容。',
          ),
          const SizedBox(height: 16),
          _buildSection(
            '1. 服务内容',
            '本应用提供简历编辑、模板选择、PDF 导出、数据备份等功能。您可以通过本应用创建、编辑、删除、导出简历，并使用本应用提供的模板进行排版和美化。',
          ),
          const SizedBox(height: 12),
          _buildSection(
            '2. 用户行为规范',
            '您在使用本应用时，应遵守以下规范：\n'
                'a) 不得利用本应用从事违法、犯罪活动。\n'
                'b) 不得侵犯他人合法权益，包括但不限于名誉权、隐私权、知识产权等。\n'
                'c) 不得发布、传播色情、暴力、赌博、诈骗等违法信息。\n'
                'd) 不得干扰本应用的正常运行，包括但不限于恶意攻击、逆向工程等。',
          ),
          const SizedBox(height: 12),
          _buildSection(
            '3. 知识产权',
            '本应用提供的模板、图标、字体等素材均为本应用所有或已获合法授权。您使用本应用生成的简历内容，其知识产权归您所有，但不得用于商业目的（除非经本应用书面许可）。本应用保留对素材的最终解释权。',
          ),
          const SizedBox(height: 12),
          _buildSection(
            '4. 免责声明',
            'a) 本应用提供的简历模板仅供参考，不构成任何专业建议。您应根据自身情况调整内容，本应用不对因使用本应用而导致的任何直接或间接损失承担责任。\n'
                'b) 本应用尽力保障服务的稳定性和安全性，但不对因不可抗力、网络故障、系统升级等导致的访问中断或数据丢失承担责任。\n'
                'c) 本应用保留随时修改、暂停或终止部分或全部服务的权利，并提前通知用户。',
          ),
          const SizedBox(height: 12),
          _buildSection(
            '5. 协议变更',
            '本应用可能适时修订本协议，更新后的协议将公布在本页面。您继续使用本应用即视为您同意修订后的协议。如您不同意修订后的协议，您有权停止使用本应用。',
          ),
          const SizedBox(height: 12),
          _buildSection(
            '6. 法律适用与争议解决',
            '本协议的订立、执行和解释均适用中华人民共和国法律。因本协议引起的任何争议，双方应友好协商解决；协商不成的，任何一方均有权将争议提交至本应用运营方所在地有管辖权的人民法院诉讼解决。',
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Color.fromARGB(221, 255, 255, 255),
          ),
        ),
      ],
    );
  }
}
