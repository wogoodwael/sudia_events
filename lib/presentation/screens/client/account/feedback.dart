import 'package:flutter/material.dart';
import 'package:sudia_events/presentation/widgets/search.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({super.key});
  List emojies = ['😊', '🙂 ', '😐', '🙁', '😡'];
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ملاحظات المستخدمين"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SearchContainernew(
              hintText: 'البحث', controller: controller, onTap: () {}),
          Column(
              children: List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(.2),
                    child: const Icon(Icons.home_filled)),
                title: const Text(
                  "مطعم الديرة ",
                  style: TextStyle(color: Colors.grey),
                ),
                subtitle: const Text("عميل مميز أنصح بقول حجوزاته"),
                trailing: Text(
                  emojies[index],
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
