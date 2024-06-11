import 'package:flutter/material.dart';
import 'package:sudia_events/presentation/widgets/search.dart';

class MessageScreen extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الرسائل'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SearchContainernew(
                        hintText: 'البحث',
                        controller: controller,
                        onTap: () {}),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                MessageTile(
                  time: '10:25',
                  message: 'Thanks a bunch! Have a great day! 😊',
                ),
                MessageTile(
                  time: '22:20 09/05/2024',
                  message: 'Great, thanks so much! 👋',
                ),
                MessageTile(
                  time: '10:45 08/05/2024',
                  message: 'Appreciate it! See you soon! 🚀',
                ),
                MessageTile(
                  time: '20:10 05/05/2024',
                  message: 'Hooray! 🎉',
                ),
                MessageTile(
                  time: '17:02 05/05/2024',
                  message: 'Your order has been successfully delivered',
                ),
                MessageTile(
                  time: '11:20 05/05/2024',
                  message: 'See you soon!',
                ),
                MessageTile(
                  time: '19:35 02/05/2024',
                  message: 'I\'m ready to drop off your delivery. 👍',
                ),
                MessageTile(
                  time: '07:55 01/05/2024',
                  message: 'Appreciate it! Hope you enjoy it!',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String time;
  final String message;

  MessageTile({required this.time, required this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(
            'assets/images/person.png'), // Replace with your image asset
      ),
      title: Text('Jamey'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
