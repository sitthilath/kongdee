import 'package:buddhistauction/Page/PartOfDetail/switch_label_notification.dart';
import 'package:buddhistauction/Provider/switch_showbottom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SwitchButton extends StatefulWidget {
  SwitchButton({Key key}) : super(key: key);

  @override
  _SwitchButtonState createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationIfHasSomeoneAuctionMoreProvider>(
      builder: (context, NotificationIfHasSomeoneAuctionMoreProvider notifier, child) {
        if (notifier.autoNotification == true) {
          print("gg");
        }
        return LabeledSwitch(
          label: 'ແຈ້ງເຕືອນຂ້ອຍຫາກມີຄົນປະມູນສູງກວ່າ',
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          // value: _isSelected,
          value: notifier.autoNotification,
          onChanged: (bool newValue) {
            notifier.toggleAutoNotification();
          },
        );
      },
    );
  }
}


