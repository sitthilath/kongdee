

import 'package:flutter/material.dart';




class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
    
        Positioned(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(

                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                  
                    // margin: const EdgeInsets.only(left: 9.0,right: 9.0,top: 62),
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Image.asset('asset/image/landing_icon.png'),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/homepage');
                    },
                    child: Text(
                      'ມາເລີ່ມກັນເລີຍ',
                      style: TextStyle(
                          fontFamily: 'boonhome',
                          fontSize: 38,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('ປະມູນ ແລະ ເຊົ່າພຣະ ຂອງຂັງ',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'boonhome')),
                  Text(
                    'ໃນແອັບພຣິເຄຊັນດຽວ',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'boonhome'),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 15,
                  ),
                  registerButton(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  loginButton(),
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

  Widget registerButton() {
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
          'ລົງທະບຽນ',
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/registerpage');
        },
      ),
    );
  }

  Widget loginButton() {
    return Container(
      width: double.maxFinite,
      height: 40,
      child: TextButton(
        child: FittedBox(
          child: Text(
            'ເຂົ້າສູ່ລະບົບ',
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/loginpage');
        },
      ),
    );
  }
}

