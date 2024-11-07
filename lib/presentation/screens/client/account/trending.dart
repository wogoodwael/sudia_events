import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class PromotionScreen extends StatelessWidget {
  const PromotionScreen({super.key});

  void _shareApp() {
    Share.share('Check out this amazing app: https://sudia_events.com');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('احصل على العروض الترويجية',style: TextStyle(fontFamily: 'JF'),),
              backgroundColor: Colors.white,

      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TrendingListTile(
            icon: Icons.share,
            text: 'شارك التطبيق',
            ontap: _shareApp,
          ),
          TrendingListTile(
            icon: Icons.group_add,
            text: 'ادعو أصدقائك',
            ontap: _shareApp,
          ),
          TrendingListTile(
            icon: Icons.card_giftcard,
            text: 'عمليات الحجز الكاملة',
            ontap: _shareApp,
          ),
          TrendingListTile(
            icon: Icons.ondemand_video,
            text: 'مشاهدة الإعلانات',
            ontap: _shareApp,
          ),
          TrendingListTile(
            icon: Icons.event,
            text: 'المشاركة في الأحداث',
            ontap: _shareApp,
          ),
          TrendingListTile(
            icon: Icons.person,
            text: 'الملف الشخصي',
            ontap: _shareApp,
          ),
          TrendingListTile(
            icon: Icons.people,
            text: 'التواصل الاجتماعي',
            ontap: _shareApp,
          ),
          TrendingListTile(
            icon: Icons.edit,
            text: 'الاستطلاعات',
            ontap: _shareApp,
          ),
          TrendingListTile(
            icon: Icons.lock,
            text: 'تسجيلات الدخول',
            ontap: _shareApp,
          ),
        ],
      ),
    );
  }
}

class TrendingListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  void Function()? ontap;

  TrendingListTile(
      {super.key, this.ontap, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey)),
      child: Center(
        child: ListTile(
          leading: Icon(icon, color: Colors.orange),
          title: Text(text,style: const TextStyle(fontFamily: 'JF'),),
          onTap: ontap,
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 20,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
