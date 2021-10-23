import 'package:flutter/material.dart';

/// Switch Button Auto Acution ////////////////////////////////////////////////
class AutoLabelSwitch extends StatelessWidget {
  const AutoLabelSwitch({
    this.label,
    this.padding,
    this.groupValue,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool groupValue;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Row(
        children: <Widget>[
          Text(
            'ປະມູນອັດຕະໂນມັດ',
            style: TextStyle(
                fontFamily: 'boonhome', fontSize: 18, color: Colors.black),
          ),
          Spacer(),
          Switch(
            value: value,
            onChanged: (bool newValue) {
              onChanged(newValue);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
