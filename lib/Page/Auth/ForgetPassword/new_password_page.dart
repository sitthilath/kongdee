import 'package:buddhistauction/Page/Auth/ForgetPassword/forget_password_page.dart';
import 'package:buddhistauction/Service/authservice.dart';
import 'package:flutter/material.dart';


class NewPassword extends StatefulWidget {
  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {

  var _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = new TextEditingController();
  final TextEditingController _cpass = new TextEditingController();


  @override
  Widget build(BuildContext context) {


    ForgetPasswordArgument args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
     appBar: AppBar(
       backgroundColor: Colors.transparent,
       elevation: 0.0,
       leading: new IconButton(
         color: Colors.black,
         icon: new Icon(Icons.arrow_back_ios),
         onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/forgetpasswordpage'))
       ),
     ),
    body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ສ້າງລະຫັດຜ່ານໃຫມ່",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text("ລະຫັດຜ່ານໃຫມ່ຄວນແຕກຕ່າງຈາກລະຫັດຜ່ານທີ່ເຄີຍໃຊ້",style: TextStyle(fontSize: 16,)),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            passTextField(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            cpassTextField(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            submitButton(args.verificationIdArg),
          ],
        ),
      ),
    ),
    );
  }

  Widget passTextField() {

        return TextFormField(
          controller: _pass,
          validator: (value) {
            if (value.isEmpty) {
              return 'ກະລຸນາປ້ອນຂໍ້ມູນ';
            }
            if (value.length < 8) {
              return 'ລະຫັດຜ່ານໜ້ອຍເກີນໄປ';
            }
            if (value != _cpass.text) {
              return 'ລະຫັດຜ່ານບໍ່ຖືກຕ້ອງ';
            }
            return null;
          },
          obscureText: true,
          decoration: InputDecoration(
            fillColor: Colors.grey[200],
            filled: true,
            border: InputBorder.none,

            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
            EdgeInsets.only(left:11, bottom: 11, top: 11, right: 15),
            hintText: 'ໃສ່ລະຫັດຜ່ານ',
          ),
        );

  }

  Widget cpassTextField() {
    return TextFormField(
      controller: _cpass,
      validator: (value) {
        if (value.isEmpty) {
          return 'ກະລຸນາປ້ອນຂໍ້ມູນ';
        }
        if (value != _pass.text) {
          return 'ລະຫັດຜ່ານບໍ່ຖືກຕ້ອງ';
        }
        return null;
      },
      obscureText: true,
      decoration: InputDecoration(
fillColor: Colors.grey[200],
        filled: true,
        border: InputBorder.none,

        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding:
        EdgeInsets.only(left:11, bottom: 11, top: 11, right: 15),
        hintText: 'ຢືນຢັນລະຫັດຜ່ານ',
      ),
    );
  }


  Widget submitButton(String verId) {
    return Container(
      width: double.maxFinite,
      height: 50,
      child: ElevatedButton(
        style: TextButton.styleFrom(
          backgroundColor: Color.fromRGBO(255, 196, 39, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(
          'ປ່ຽນລະຫັດຜ່ານ',
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

            AuthService().forgetPassword(_pass.text, verId, context);
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Processing Data')));
          }
        },
      ),
    );
  }
}
