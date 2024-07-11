import 'package:flutter/material.dart';

class InviteFriendsScreen extends StatelessWidget {
  InviteFriendsScreen({super.key});
  List images = [
    'assets/images/Twitter.png',
    'assets/images/Facebook.png',
    'assets/images/Messenger.png',
    'assets/images/Discord.png',
    'assets/images/Skype.png',
    'assets/images/Telegram.png',
    'assets/images/Weechat.png',
    'assets/images/Whatsapp.png'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("دعوة اصدقائك"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
              2,
              (index) => SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index2) {
                        int combinedIndex = index * 4 + index2;
                        return Center(
                          child: Image.asset(
                            images[combinedIndex],
                            width: 70,
                          ),
                        );
                      }),
                    ),
                  )),
        ));
  }
}
