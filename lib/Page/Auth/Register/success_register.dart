import 'package:flutter/material.dart';

class SuccessRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Stack(children: [

        Positioned(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(

                    // margin: const EdgeInsets.only(left: 9.0,right: 9.0,top: 62),
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Image.asset('asset/image/success_register_logo.png'),
                  ),

                  Text(
                    'ສຳເລັດ!',
                    style: TextStyle(
                        fontFamily: 'boonhome',
                        fontSize: 38,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('ເຈົ້າສໍາເລັດລົງທະບຽນໃນເເອບຂອງພວກເຮົາເເລ້ວ',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'boonhome')),
                  Text(
                    'ເຊີ່ງດຽວນີີ້ ເຈົ້າສາມາດນໍາໃຊ້ເເອັບໃດ້ເລີຍ',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'boonhome'),
                  ),


                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  registerButton(context),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }



  Widget registerButton(BuildContext context) {
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
          'ນຳໃຊ້ເລີຍ',
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/homepage", (Route<dynamic> route) => false);
        },
      ),
    );
  }

}
