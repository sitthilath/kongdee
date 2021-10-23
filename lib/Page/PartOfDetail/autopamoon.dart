
import 'package:buddhistauction/Page/PartOfDetail/auto_label_switch.dart';
import 'package:buddhistauction/Provider/switch_showbottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class AutoPaMoon extends StatefulWidget {
  AutoPaMoon({Key key}) : super(key: key);

  @override
  _AutoPaMoonState createState() => _AutoPaMoonState();
}

class _AutoPaMoonState extends State<AutoPaMoon> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AutoAuctionProvider>(
        builder: (context, notifier, child) {
          if (notifier.autoAuction == true) {
            print("_text");

              SchedulerBinding.instance.addPostFrameCallback((_) {
                notifier.priceController.clear();
              });



          }
          return AutoLabelSwitch(
            label: 'ປະມູນອັດຕະໂນມັດ',
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            // value: _isSelected,
            value: notifier.autoAuction,

            onChanged: (bool newValue) {
              notifier.toggleAutoAuction();
            },
          );
        });
  }
}