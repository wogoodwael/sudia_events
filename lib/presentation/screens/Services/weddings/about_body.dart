import 'package:flutter/material.dart';

class AboutBody extends StatefulWidget {
  const AboutBody({super.key});

  @override
  State<AboutBody> createState() => _AboutBodyState();
}

class _AboutBodyState extends State<AboutBody> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            width: 50,
            child: Text(
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                """قاعة غيم هي إحدى القاعات الفاخرة المتعددة الاستخدامات في مدينة جدة بالمملكة العربية السعودية. تتميز بتصميمها العصري والفاخر، وتوفر مساحة مثالية لإقامة مختلف أنواع الفعاليات والمناسبات مثل الحفلات الخاصة، والمؤتمرات، والمعارض، وحفلات الزفاف، والاجتماعات الخاصة، والفعاليات الثقافية والفنية الأخرى.
                                    """),
          ),
        ),
      ],
    );
  }
}
