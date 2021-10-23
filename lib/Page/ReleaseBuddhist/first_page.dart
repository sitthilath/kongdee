

import 'package:buddhistauction/Model/buddhist_type.dart';
import 'package:buddhistauction/Page/ReleaseBuddhist/second_page.dart';
import '../../Provider/StoreData/store_release_buddhist.dart';
import 'package:buddhistauction/Service/service_api.dart';

import 'package:buddhistauction/TransitionPageRoute/slide_left_right.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  var _key = GlobalKey<FormState>();

  // File _imageBig, _imageSmall1, _imageSmall2, _imageSmall3, _imageSmall4;
  // final List<File> listImage = [];

  bool isSelected = true;
  int _value;
  TextEditingController _nameBuddhist = new TextEditingController();
  TextEditingController _conditionBuddhist = new TextEditingController();



  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
      leading: Consumer<StoreReleaseBuddhistProvider>(builder: (context, storeRelease, child) =>  new IconButton(
      icon:

      new Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context,true);
            storeRelease.resetState();
           }
        ),
      ),
        backgroundColor: Color.fromRGBO(255, 196, 39, 1),
        centerTitle: true,
        title: Text(
          "ປ່ອຍເຄື່ອງ",
          style: TextStyle(
            color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'boonhome'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _key,
            child: Column(
              children: <Widget>[

                imageSelectedBig(),
                SizedBox(
                  height: 32,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ລົງຮູບໄດ້ອີກ 4 ຮູບ",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'boonhome'),
                    )),
                SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 8.0,
                  direction: Axis.horizontal,
                  children: [
                    imageSelectedSmall1(),

                    imageSelectedSmall2(),

                    imageSelectedSmall3(),

                    imageSelectedSmall4(),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ຊື່ເຄື່ອງ",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'boonhome'),
                    )),
                SizedBox(
                  height: 10,
                ),
                Consumer<StoreReleaseBuddhistProvider>(

                  builder: (context, srb, child) {
                    if (_nameBuddhist.text != srb.itemName) {
                      // Or check if appState.username != null or what ever your use case is.
                      _nameBuddhist.text = srb.itemName ?? '';

                    }

                    return TextFormField(
                      controller: _nameBuddhist,

                      onChanged: (value) {

                            srb.setItemName(value);
                            srb.setCtrlItemName(_nameBuddhist);


                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'ກະລຸນາປ້ອນຂໍ້ມູນ';
                        }else if(value.length < 3){
                          return 'ຂໍ້ຄວາມສັ້ນເກີນໄປ';
                        }else if(value.length >100){
                          return 'ຂໍ້ຄວາມຍາວເກີນໄປ';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ແທັກປະເພດ",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'boonhome'),
                    )),
                buddhistType(),
                SizedBox(
                  height: 20,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ສະພາບເຄື່ອງ",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'boonhome'),
                    )),
                SizedBox(
                  height: 10,
                ),
                Consumer<StoreReleaseBuddhistProvider>(

                  builder: (context, srb, child) {
                    if (_conditionBuddhist.text != srb.itemCondition) {
                      // Or check if appState.username != null or what ever your use case is.
                      _conditionBuddhist.text = srb.itemCondition ?? '';
                    }

                    return TextFormField(
                      controller: _conditionBuddhist,
                      onChanged: (value) {
                        srb.setItemCondition(value);
                        srb.setCtrlItemCondition(_conditionBuddhist);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'ກະລຸນາປ້ອນຂໍ້ມູນ';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                submitButton(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 80.0,
          child: numberPage(),
        ),
      ),
    );
  }

  ///------------------num 1 2 3 4
  Widget numberPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromRGBO(255, 196, 39, 1),
                  child: Text("1",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'boonhome')),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("ລົງຮູບ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'boonhome')),
              ],
            ),
            Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                alignment: Alignment.topCenter,
                child: Text(
                  ". . . .",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                )),
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 253, 200, 200),
                  child: Text("2",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'boonhome')),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("ຂໍ້ມູນ",
                    style: TextStyle(
                        color: Color.fromARGB(255, 253, 200, 200),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'boonhome')),
              ],
            ),
            Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                alignment: Alignment.topCenter,
                child: Text(
                  ". . . .",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                )),
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 253, 200, 200),
                  child: Text("3",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'boonhome')),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("ລາຄາ",
                    style: TextStyle(
                        color: Color.fromARGB(255, 253, 200, 200),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'boonhome')),
              ],
            ),
            Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                alignment: Alignment.topCenter,
                child: Text(
                  ". . . .",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                )),
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 253, 200, 200),
                  child: Text("4",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'boonhome')),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("ຈັດສົ່ງ",
                    style: TextStyle(
                        color: Color.fromARGB(255, 253, 200, 200),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'boonhome')),
              ],
            ),
          ],
        ),
      ],
    );
  }

  ///Widget Type Buddhist/////////////////////////////////////////////////////////////////
  Widget buddhistType() {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.10,
      child: Row(
        children: [
          Expanded(
            child: FutureBuilder<BuddhistType>(
                future: ServiceApi.fetchBuddhistType(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    final _buddhistListType = snapshot.data.data;
                    return Container(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _buddhistListType.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Consumer<StoreReleaseBuddhistProvider>(
                              builder: (context, srb, child) {
                                if (_value != srb.indexItemType) {
                                  // Or check if appState.username != null or what ever your use case is.
                                  _value = srb.indexItemType ?? '';
                                }
                                return Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: ChoiceChip(
                                    backgroundColor:
                                    Color.fromARGB(255, 253, 200, 200),
                                    selectedColor:
                                    Color.fromRGBO(255, 196, 39, 1),
                                    labelStyle: _value == index
                                        ? TextStyle(color: Colors.black)
                                        : TextStyle(color: Colors.black),
                                    label: Text(
                                        '${_buddhistListType[index].name}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'boonhome')),
                                    selected: _value == index,
                                    onSelected: (bool selected) {
                                      srb.setItemType(
                                          '${_buddhistListType[index].id}',index);
                                      setState(() {
                                        _value = selected ? index : null;
                                      });
                                      print(_buddhistListType[index].id);
                                    },
                                    //  selectedColor: isSelected ? Colors.black : Colors.white
                                  ),
                                );
                              },
                            );
                          }),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ],
      ),
    );
  }

  ///Widget Type Buddhist/////////////////////////////////////////////////////////////

  ///Widget SelectImage All--------------------------------------------------------------

  Widget imageSelectedBig() {
    return Center(
      child: Consumer<StoreReleaseBuddhistProvider>(
        builder: (context, value, child) =>
         Stack(
          children: [

            value.imageBig != null
                  ?
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        value.imageBig,
                        width: 100,
                        height: 90,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  )
                  :
    GestureDetector(
        onTap: () {
          _showPickerBig(context);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.red,
          ),
          width: 100,
          height: 90,
          child: Icon(
            Icons.add_photo_alternate_outlined,
            color: Colors.white,
            size: 40,
          ),
        ),
    ),
            value.imageBig != null
                ? value.imageSmall1 == null ?
            Positioned(
              top: 0,
              right: 0,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                maxRadius: 10,

                  child: GestureDetector(
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 18,
                    ),
                    onTap: () {


                        if(mounted){

                          value.setDeleteListImage(0);

                          value.setImageBig(null);



                        }

                    },
                  ),
                ),

            ) : SizedBox()
                : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget imageSelectedSmall1() {
    return Consumer<StoreReleaseBuddhistProvider>(
      builder: (context, value, child) =>
      Stack(children: [
         value.imageSmall1 != null
              ?
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      value.imageSmall1,
                      width: 60,
                      height: 50,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                )

              : GestureDetector(
           onTap: () {
             _showPickerSmall1(context);
           },
           child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.red,
            ),
            width: 60,
            height: 50,
            child: Icon(
              Icons.add_photo_alternate_outlined,
              color: Colors.white,
            ),
          ),
        ),
        value.imageSmall1 != null
            ? value.imageSmall2 == null ?
        Positioned(
          top: 0,
          right: 0,
          child: CircleAvatar(
            backgroundColor: Colors.red,
            maxRadius: 8,
            child: GestureDetector(
              child: Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 14,
              ),
              onTap: () {

                value.setDeleteListImage(1);

                value.setImageSmall1(null);



              },
            ),
          ),
        ) : SizedBox()
            : value.imageBig == null
            ? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Color.fromARGB(255, 253, 220, 220),
          ),
          width: 60,
          height: 50,
        )
            : SizedBox()
      ]),
    );
  }

  Widget imageSelectedSmall2() {
    return Consumer<StoreReleaseBuddhistProvider>(
      builder: (context, value, child) =>
      Stack(children: [
         value.imageSmall2 != null
              ?
               Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.file(
                    value.imageSmall2,
                    width: 60,
                    height: 50,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              )
              : GestureDetector(
           onTap: () {
             _showPickerSmall2(context);
           },
           child:Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.red,
            ),
            width: 60,
            height: 50,
            child: Icon(
              Icons.add_photo_alternate_outlined,
              color: Colors.white,
            ),
          ),
        ),
        value.imageSmall2 != null
            ? value.imageSmall3 == null ?
        Positioned(
          top: 0,
          right: 0,
          child: CircleAvatar(
            backgroundColor: Colors.red,
            maxRadius: 8,
            child: GestureDetector(
              child: Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 14,
              ),
              onTap: () {

                value.setDeleteListImage(2);

                value.setImageSmall2(null);

              },
            ),
          ),
        ) : SizedBox()
            : value.imageSmall1 == null
            ? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Color.fromARGB(255, 253, 220, 220),
          ),
          width: 60,
          height: 50,
        )
            : SizedBox()
      ]),
    );
  }

  Widget imageSelectedSmall3() {
    return Consumer<StoreReleaseBuddhistProvider>(
      builder: (context, value, child) =>
      Stack(children: [
         value.imageSmall3 != null
              ?  Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.file(
                    value.imageSmall3,
                    width: 60,
                    height: 50,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              )
              : GestureDetector(
           onTap: () {
             _showPickerSmall3(context);
           },
           child:Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.red,
            ),
            width: 60,
            height: 50,
            child: Icon(
              Icons.add_photo_alternate_outlined,
              color: Colors.white,
            ),
          ),
        ),
        value.imageSmall3 != null
            ? value.imageSmall4 == null ?
        Positioned(
          top: 0,
          right: 0,
          child: CircleAvatar(
            backgroundColor: Colors.red,
            maxRadius: 8,
            child: GestureDetector(
              child: Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 14,
              ),
              onTap: () {

                value.setDeleteListImage(3);

                value.setImageSmall3(null);

              },
            ),
          ),
        ) : SizedBox()
            : value.imageSmall2 == null
            ? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Color.fromARGB(255, 253, 220, 220),
          ),
          width: 60,
          height: 50,
        )
            : SizedBox()
      ]),
    );
  }

  Widget imageSelectedSmall4() {
    return Consumer<StoreReleaseBuddhistProvider>(
      builder: (context, value, child) =>
       Stack(
        children: [
           value.imageSmall4 != null
                ?  Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      value.imageSmall4,
                      width: 60,
                      height: 50,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                )
                : GestureDetector(
             onTap: () {
               _showPickerSmall4(context);
             },
             child:Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.red,
              ),
              width: 60,
              height: 50,
              child: Icon(
                Icons.add_photo_alternate_outlined,
                color: Colors.white,
              ),
            ),
          ),
          value.imageSmall4 != null
              ? Positioned(
            top: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: Colors.red,
              maxRadius: 8,
              child: GestureDetector(
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 14,
                ),
                onTap: () {

                  value.setDeleteListImage(4);

                  value.setImageSmall4(null);


                },
              ),
            ),
          )
              : value.imageSmall3 == null
              ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Color.fromARGB(255, 253, 220, 220),
            ),
            width: 60,
            height: 50,
          )
              : SizedBox()
        ],
      ),
    );
  }



  ///End Widget return/////////////////////////////////////////////////////////


  ///-------------------ShowPickerBig Widget
  void _showPickerBig(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  Consumer<StoreReleaseBuddhistProvider>(
                    builder: (context, storeRelease, child) =>
                     new ListTile(
                        leading: new Icon(Icons.photo_library),
                        title: new Text('Photo Library'),
                        onTap: () {
                          storeRelease.imgFromGalleryBig();
                          Navigator.of(context).pop();
                        }),
                  ),
                  Consumer<StoreReleaseBuddhistProvider>(
                  builder: (context, storeRelease, child) =>
          new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      storeRelease.imgFromCameraBig();
                      Navigator.of(context).pop();
                    },
                  ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  ///-------------------ShowPickerSmall1 Widget
  void _showPickerSmall1(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
              Consumer<StoreReleaseBuddhistProvider>(
              builder: (context, storeRelease, child) =>
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        storeRelease.imgFromGallerySmall1();
                        Navigator.of(context).pop();
                      }),
              ),
              Consumer<StoreReleaseBuddhistProvider>(
              builder: (context, storeRelease, child) =>
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      storeRelease.imgFromCameraSmall1();
                      Navigator.of(context).pop();
                    },
                  ),
              ),
                ],
              ),
            ),
          );
        });
  }

  ///-------------------ShowPickerSmall2 Widget
  void _showPickerSmall2(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
              Consumer<StoreReleaseBuddhistProvider>(
              builder: (context, storeRelease, child) =>
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        storeRelease.imgFromGallerySmall2();
                        Navigator.of(context).pop();
                      }),
              ),
              Consumer<StoreReleaseBuddhistProvider>(
              builder: (context, storeRelease, child) =>
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      storeRelease.imgFromCameraSmall2();
                      Navigator.of(context).pop();
                    },
                  ),
              ),
                ],
              ),
            ),
          );
        });
  }

  ///-------------------ShowPickerSmall3 Widget
  void _showPickerSmall3(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
              Consumer<StoreReleaseBuddhistProvider>(
              builder: (context, storeRelease, child) =>
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        storeRelease.imgFromGallerySmall3();
                        Navigator.of(context).pop();
                      }),
              ),
              Consumer<StoreReleaseBuddhistProvider>(
              builder: (context, storeRelease, child) =>
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      storeRelease.imgFromCameraSmall3();
                      Navigator.of(context).pop();
                    },
                  ),
              ),
                ],
              ),
            ),
          );
        });
  }

  ///-------------------ShowPickerSmall4 Widget
  void _showPickerSmall4(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
              Consumer<StoreReleaseBuddhistProvider>(
              builder: (context, storeRelease, child) =>
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        storeRelease.imgFromGallerySmall4();
                        Navigator.of(context).pop();
                      }),
              ),
              Consumer<StoreReleaseBuddhistProvider>(
              builder: (context, storeRelease, child) =>
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      storeRelease.imgFromCameraSmall4();
                      Navigator.of(context).pop();
                    },
                  ),
              ),
                ],
              ),
            ),
          );
        });
  }

  ///-------------------ShowPickerSmall5 Widget


  ///-------------------submitButton Widget
  Widget submitButton() {
    return Container(
      width: double.maxFinite,
      height: 40,
      child: ElevatedButton(
        style: TextButton.styleFrom(
          backgroundColor:Color.fromRGBO(255, 196, 39, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),

        child: Text(
          'ຕໍ່ໄປ',
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (_key.currentState.validate()) {
            _key.currentState.save();

            var buddhistType = Provider.of<StoreReleaseBuddhistProvider>(context,listen: false).itemType;
            if (Provider.of<StoreReleaseBuddhistProvider>(context,listen: false).imageBig == null) {
              Fluttertoast.showToast(
                  msg: "ກະລຸນາເພີ່ມຮູບ",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.redAccent,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if(buddhistType == null){
              Fluttertoast.showToast(
                  msg: "ກະລຸນາເລືອກປະເພດ",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.redAccent,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            else {
              Navigator.push(context, SlideRightRoute(page: SecondPage()));
            }
          } else {
            Fluttertoast.showToast(
                msg: "ປ້ອນຂໍ້ມູນໃຫ້ຄົບຖ້ວນ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.redAccent,
                textColor: Colors.white,
                fontSize: 16.0);  }
        },
      ),
    );
  }
}
