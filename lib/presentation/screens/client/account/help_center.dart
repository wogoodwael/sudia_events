import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/presentation/widgets/search.dart';

class HelpCenterScreen extends StatelessWidget {
  HelpCenterScreen({super.key});
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز المساعدة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
      ),
      body: Column(
        children: [
          SearchContainernew(
              hintText: 'البحث', controller: controller, onTap: () {}),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                CategoryTab(label: 'عام', isSelected: true),
                CategoryTab(label: 'الحساب'),
                CategoryTab(label: 'الطلبات'),
                CategoryTab(label: 'طرق الدفع '),
                // Add more tabs as needed
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                HelpListItem(
                  question: 'كيف أقوم بإنشاء حساب جديد؟',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpDetailScreen(),
                      ),
                    );
                  },
                ),
                const HelpListItem(
                    question: 'لقد نسيت كلمة مروري كيف يمكنني اعادتها ؟'),
                const HelpListItem(
                    question:
                        'لدي مشكله في تسجيل الدخول الي حسابي كيف يمكنني حلها  ؟'),
                const HelpListItem(question: 'كيف يمكنني اعاده طلب اوردر جديد؟'),
                const HelpListItem(
                    question:
                        'لدي مشكله في طرق الدفع كيف يمكنني حلها ؟'),
                const HelpListItem(
                    question:
                        'اريد ان الغي اوردر تم تاكيده كيف يمكنني ذالك ؟'),
                const HelpListItem(
                    question:
                        'اين يمكنني ان اجد التفاصيل الخاصه بكل منتج ؟'),
                const HelpListItem(
                    question:
                        'لدي مشكله في حساب كميه الاوردرات كيف يمكنني الابلاغ عن ذالك ؟'),
                const HelpListItem(
                    question:
                        'كيف استخدم ميزه معينه من مميزات التطبيق ؟'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  backgroundColor: primary,
                  onPressed: () {
                    // Handle email action
                  },
                  child: const Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  backgroundColor: primary,
                  onPressed: () {
                    // Handle phone call action
                  },
                  child: const Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryTab extends StatelessWidget {
  final String label;
  final bool isSelected;

  const CategoryTab({super.key, required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.red : Colors.grey[200],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class HelpListItem extends StatelessWidget {
  final String question;
  final VoidCallback? onTap;

  const HelpListItem({super.key, required this.question, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(question),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class HelpDetailScreen extends StatelessWidget {
  const HelpDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المساعدة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'كيف أقوم بإنشاء حساب جديد؟',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'لإنشاء حساب جديد، يرجى اتباع الخطوات البسيطة التالية:\n\n'
              '1. افتح التطبيق وانتقل إلى شاشة تسجيل الدخول.\n'
              '2. أسفل نموذج تسجيل الدخول، سترى خيار "تسجيل". اضغط عليه.\n'
              '3. سيطلب منك إدخال رقم هاتفك والبريد الإلكتروني والاسم الكامل. من المستحسن إدخال رقم هاتف صالح.\n'
              '4. بعد إدخال رقم الهاتف والبريد الإلكتروني والاسم الكامل، اضغط على زر "تسجيل".\n'
              '5. سيتم إرسال رمز إلى هاتفك للتحقق. يرجى التحقق من صندوق الوارد الخاص بك وإدخال الرمز في شاشة التحقق للتحقق من صحة الحساب.\n'
              '6. بعد التحقق من حسابك، سيتم إنشاء حسابك بنجاح.\n\n'
              'لقد انتهيت الآن من إنشاء حسابك.\n\n'
              'إذا واجهت أي مشاكل أثناء عملية الاشتراك، فلا تتردد في التواصل مع فريق الدعم لدينا للحصول على المساعدة.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
