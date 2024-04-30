import 'package:flutter/material.dart';
import 'package:sudia_events/data/model/settings_model.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({
    super.key,
    required,
    required this.settingsModel, required this.color,
  });
  final SettingsModel settingsModel;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: ListTile(
            title: Text(
              settingsModel.title,
              textDirection: TextDirection.rtl,
            ),
            subtitleTextStyle: TextStyle(color: Colors.grey),
            trailing: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 15,
                  child: Icon(
                    settingsModel.trailing,
                    color: color,
                    size: 15,
                  )),
            ),
            leading: GestureDetector(
              onTap: settingsModel.ontap,
              child: Icon(
                settingsModel.leading,
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
