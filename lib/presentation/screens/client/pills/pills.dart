import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/client/settings/widgets/header_services.dart';

class PillScreen extends StatelessWidget {
  const PillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> firstRow = [
      const Text(' '),
      const Text(' المبلغ'),
      const Text(' تاريخ الحجز '),
      const Text(' رقم الفاتورة  '),
    ];

    final List<Widget> data = [
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, pilldetails);
        },
        child: const Icon(
          Icons.arrow_back_ios,
          size: 10,
        ),
      ),
      const Text(' 4300'),
      const Text('2/8/2024'),
      const Text(' 00255555712 '),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              const Header(
                text: 'الفواتير',
                paddingButtom: 50,
                paddingTop: 70,
              ),
              Positioned(
                right: 10,
                top: 50,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Transform.scale(
                    scale: 1.5,
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            flex: 4,
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: Colors.grey[100],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: firstRow,
                      ),
                      const Divider(indent: 10, endIndent: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: data,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
