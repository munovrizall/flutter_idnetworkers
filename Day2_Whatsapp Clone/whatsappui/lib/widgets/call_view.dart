import 'package:flutter/material.dart';
import 'package:whatsappui/models/status.dart';
import '../theme.dart';

class CallView extends StatelessWidget {
  const CallView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: statusList.length,
        itemBuilder: (context, index) {
          final status = statusList[index];
          return ListTile(
            leading: const Icon(
              Icons.account_circle,
              size: 50,
              color: Colors.black,
            ),
            title: Text(
              status.name,
              style: customTextStyle,
            ),
            subtitle: Text(
                status.statusDate
            ),
            trailing: Icon(
              Icons.call,
              color: whatsAppLightGreen,
            ),
          );
        }
    );
  }
}
