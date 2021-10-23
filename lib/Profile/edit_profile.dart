
import 'dart:convert';
import 'dart:io';

import 'package:buddhistauction/Provider/StoreData/store_token.dart';
import 'package:buddhistauction/Provider/user_view_model.dart';
import 'package:buddhistauction/Service/service_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../const_api.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  File _imageProfile;
  final picker = ImagePicker();

  UserViewModel _userViewModel;

  @override
  void initState() {
    _userViewModel = Provider.of<UserViewModel>(context,listen:false);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _userViewModel.fetchUser(context);
      name.text = _userViewModel.userList.name;
      surname.text = _userViewModel.userList.surname;

      phone.text = _userViewModel.userList.phoneNumber;

    });

    super.initState();
  }


  @override
  void dispose() {

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if(mounted){
          _userViewModel.fetchUser(context);
        }
      });


    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        title: Text("ແກ້ໄຂໂປຣຟາຍ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 196, 39, 1),

      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Consumer<UserViewModel>(
                      builder: (context, viewModel, child) =>
                       imageSelected(viewModel.userList.picture)),
                  nameTextField(),
                  surnameTextField(),
                  SizedBox(height: 20,),
                  submitButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget submitButton() {
    return Container(
      width: double.maxFinite,
      height: 40,
      child: ElevatedButton(
        style: TextButton.styleFrom(
          backgroundColor: Color.fromRGBO(255, 196, 39, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),

        child: Text(
          'ບັນທຶກ',
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            alertRequirePassword(context,name,surname,phone,password);

          } else
          {
            Fluttertoast.showToast(
                msg: "ປ້ອນຂໍ້ມູນໃຫ້ຄົບຖ້ວນ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.redAccent,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
      ),
    );
  }

  Widget nameTextField() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ຊື່",style: TextStyle(fontSize: 18,color: Colors.black),),
            Container(

              child: TextFormField(

                controller: name,

                autofocus: false,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'ກະລຸນາປ້ອນຂໍ້ມູນ';

                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "ຊື່",
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 12.0, horizontal: 5.0),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
          ],
        );


  }

  Widget surnameTextField() {

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ນາມສະກຸນ",style: TextStyle(fontSize: 18,color: Colors.black),),
            Container(


              child: TextFormField(
                controller: surname,

                validator: (value) {
                  if (value.isEmpty) {
                    return 'ກະລຸນາປ້ອນຂໍ້ມູນ';

                  }
                  return null;
                },
                decoration: InputDecoration(

                  hintText: 'ນາມສະກຸນ',
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 12.0, horizontal: 5.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
          ],
        );

  }


  Widget imageSelected(String imageProfile) {
    return GestureDetector(
      onTap: () {
        _showPicker(context);
      },
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Color.fromRGBO(255, 196, 39, 1),
            radius: 90,
            child: Consumer<UserViewModel>(
              builder: (context, viewModel, child) =>
               CircleAvatar(
                backgroundColor: Colors.transparent,

                radius: 87,
                backgroundImage: _imageProfile == null
                    ? NetworkImage(
                    "${viewModel.userList.picture}")
                    : FileImage(_imageProfile),
              ),
            ),
          ),
          Positioned(
               right: 0,
              bottom: 0,
              child: CircleAvatar(backgroundColor: Color.fromRGBO(255, 196, 39, 1),radius: 30,child: CircleAvatar(backgroundColor: Colors.white,radius: 28,child: Icon(Icons.camera_alt_outlined,color:Colors.grey)),)),
        ],
      ),
    );
  }

  Future _imgFromCamera() async {
    final pickedFile =
    await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1,ratioY: 1),
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Image Cropper',
          toolbarColor: Color.fromRGBO(255, 196, 39, 1),
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: 'Image Cropper',
      ),
      compressQuality: 50,
      maxWidth:600,
      maxHeight:800,
    );
      if (pickedFile != null) {
        File rotatedImage =
        await FlutterExifRotation.rotateImage(path: croppedFile.path);
        setState(() {
        _imageProfile = rotatedImage;
      });
      } else {
        print('No image selected.');
      }

  }

  Future _imgFromGallery() async {
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1,ratioY: 1),
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Image Cropper',
          toolbarColor: Color.fromRGBO(255, 196, 39, 1),
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: 'Image Cropper',
      ),
      compressQuality: 50,
      maxWidth:600,
      maxHeight:800,
    );
    setState(() {
      if (pickedFile != null) {
        _imageProfile = croppedFile;

      } else {
        print('No image selected.');
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }


  Future<Map<String, dynamic>> _uploadProfile(File image,String name,String surname,String phone,String password) async {


    String token = await StoreTokenProvider().getToken();
    final headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.acceptHeader: "application/json"
    };

    Uri apiUrl = Uri.parse("$API_URL/editProfile");

    final imageUploadRequest = http.MultipartRequest('post', apiUrl);



    if(image != null){
      final file = await http.MultipartFile.fromPath('picture', image.path);
      imageUploadRequest.files.add(file);
    }


    imageUploadRequest.headers.addAll(headers);
    imageUploadRequest.fields['name'] = name;
    imageUploadRequest.fields['surname'] = surname;
    imageUploadRequest.fields['phone_number'] = phone;
    imageUploadRequest.fields['password'] = password;

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      if(response.statusCode == 200){
        final Map<String, dynamic> responseData = json.decode(response.body);
        Navigator.pop(context);
        ServiceAlert.alertSuccess(context,'ແກ້ໄຂສຳເລັດ');

        return responseData;
      }
     else if(response.statusCode == 403){
        Navigator.pop(context);
        ServiceAlert.alertError(context,   "ລະຫັດຜ່ານບໍ່ຖືກຕ້ອງ");

        return null;
      }
     else if (response.statusCode == 422) {
        Navigator.pop(context);
        ServiceAlert.alertError(context,   "ກະລຸນາປ້ອນລະຫັດຜ່ານ");
        return null;
      }else{
        Navigator.pop(context);
        ServiceAlert.alertError(context,'ເກີດຂໍ້ຜິດພາດ');
        throw("Error");
      }

    } catch (e) {
      print(e);
      return null;
    }
  }

  // void _startUploading(File image,String name,String surname,String phone,String password) async {
  //   if (image != null) {
  //     final Map<String, dynamic> response = await _uploadProfile(image,name,surname,phone,password);
  //     print("response $response");
  //     // Check if any error occured
  //     if (response == null) {
  //       Navigator.pop(context);
  //       ServiceAlert.alertError(context,'ເກີດຂໍ້ຜິດພາດ');
  //
  //     }else{
  //       Navigator.pop(context);
  //       ServiceAlert.alertSuccess(context,'ແກ້ໄຂສຳເລັດ');
  //     }
  //   } else {
  //     Navigator.pop(context);
  //     ServiceAlert.alertError(context,'ເກີດຂໍ້ຜິດພາດ');
  //
  //   }
  // }


  void alertRequirePassword(BuildContext context,TextEditingController name,TextEditingController surname,TextEditingController phone,TextEditingController password) {

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext ctx) {
          return  CupertinoAlertDialog(

            title: Center(child: Text("ປ້ອນລະຫັດຜ່ານເພື່ອຢືນຢັນ", style: TextStyle(fontFamily: 'boonhome',fontSize: 18,fontWeight: FontWeight.bold))),

            content: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(

                    controller: password,

                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.only(left:11, bottom: 11, top: 11, right: 15),
                      hintText: 'ລະຫັດຜ່ານ',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5,right: 5,top:10),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: TextButton.styleFrom(

                      backgroundColor: Color.fromARGB(255, 62, 13, 184) ,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      'ຢືນຢັນ',
                      style: TextStyle(fontFamily: 'boonhome',fontSize: 16,fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ServiceAlert.alertLoading(context);
                      _uploadProfile(_imageProfile, name.text.trim(), surname.text.trim(),phone.text.trim(),password.text.trim());
                    },
                  ),
                ),
              ],
            ),

          );
        });
  }

}


