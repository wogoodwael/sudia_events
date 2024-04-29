import 'package:flutter/material.dart';
import 'package:sudia_events/data/model/acoount_list_tile_model.dart';

class AccountList extends StatelessWidget {
  const AccountList({super.key, required this.accountListModel, required});
  final AccountListModel accountListModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: ListTile(
            title: Text(
              accountListModel.title,
              textDirection: TextDirection.rtl,
            ),
            subtitleTextStyle: TextStyle(color: Colors.grey),
            subtitle: Text(
              accountListModel.subTitle,
              textDirection: TextDirection.rtl,
            ),
            trailing: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 15,
                  child: Icon(
                    accountListModel.trailing,
                    size: 15,
                  )),
            ),
            leading: GestureDetector(
              onTap: accountListModel.ontap,
              child: Icon(
                accountListModel.leading,
                size: 15,
              ),
            ),
          ),
        ),
        Divider(
          height: 0,
          endIndent: 15,
          indent: 15,
          color: Colors.grey[300],
        ),
      ],
    );
  }
}
