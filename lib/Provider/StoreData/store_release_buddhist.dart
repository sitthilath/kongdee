import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class StoreReleaseBuddhistProvider extends ChangeNotifier{
  int _indexItemType,_indexPayThrough,_indexDelivery;
  String _itemCondition;
  String _itemName,_itemType,_information,_dateAuction,_timeAuction,_datetimeAuction,_place,_priceStart,_priceSmallest;
  String _payThrough;
  //_bankName,_accountName,_accountNumber;
  String _delivery;
  //_placeDelivery,_phoneNumber,_moreDetail;
  List<File> _listImage = [];
  File _imageBig,_imageSmall1,_imageSmall2,_imageSmall3,_imageSmall4;
  TextEditingController _ctrlDateAuction,_ctrlTimeAuction,_ctrlItemCondition,_ctrlItemName,_ctrlInformation,_ctrlPriceStart,_ctrlPriceSmallest;

      //_ctrlBankName,_ctrlAccountName,_ctrlAccountNumber,_ctrlPlaceDelivery,_ctrlPhoneNumber,_ctrlMoreDetail;


  File get imageBig =>_imageBig;
  File get imageSmall1 =>_imageSmall1;
  File get imageSmall2 =>_imageSmall2;
  File get imageSmall3 =>_imageSmall3;
  File get imageSmall4 =>_imageSmall4;

  int get indexDelivery => _indexDelivery;
  int get indexItemType => _indexItemType;
  int get indexPayThrough => _indexPayThrough;
  String get itemName => _itemName;
  String get itemType => _itemType;
  String get itemCondition => _itemCondition;
  List<File> get listImage => _listImage;
  String get information => _information;
  String get dateAuction => _dateAuction;
  String get timeAuction => _timeAuction;
  String get datetimeAuction => _datetimeAuction;
  String get place => _place;
  String get priceStart => _priceStart;
  String get priceSmallest => _priceSmallest;

   String get payThrough => _payThrough;
  // String get bankName => _bankName;
  // String get accountName => _accountName;
  // String get accountNumber => _accountNumber;
  //
  String get delivery => _delivery;
  // String get placeDelivery => _placeDelivery;
  // String get phoneNumber => _phoneNumber;
  // String get moreDetail => _moreDetail;

  TextEditingController get ctrlDateAuction => _ctrlDateAuction;
  TextEditingController get ctrlTimeAuction => _ctrlTimeAuction;
  TextEditingController get ctrlItemCondition => _ctrlItemCondition;
  TextEditingController get ctrlItemName => _ctrlItemName;
  TextEditingController get ctrlInformation => _ctrlInformation;
  TextEditingController get ctrlPriceStart => _ctrlPriceStart;
  TextEditingController get ctrlPriceSmallest => _ctrlPriceSmallest;
  // TextEditingController get ctrlBankName => _ctrlBankName;
  // TextEditingController get ctrlAccountName => _ctrlAccountName;
  // TextEditingController get ctrlAccountNumber => _ctrlAccountNumber;
  // TextEditingController get ctrlPlaceDelivery => _ctrlPlaceDelivery;
  // TextEditingController get ctrlPhoneNumber => _ctrlPhoneNumber;
  // TextEditingController get ctrlMoreDetail => _ctrlMoreDetail;



  setImageBig(File imageBig){
  _imageBig = imageBig;
  notifyListeners();
  }

  setImageSmall1(File imageSmall1){
    _imageSmall1 = imageSmall1;
    notifyListeners();
  }

  setImageSmall2(File imageSmall2){
    _imageSmall2 = imageSmall2;
    notifyListeners();
  }

  setImageSmall3(File imageSmall3){
    _imageSmall3 = imageSmall3;
    notifyListeners();
  }

  setImageSmall4(File imageSmall4){
    _imageSmall4 = imageSmall4;
    notifyListeners();
  }



  setListImage(File listImage){
    _listImage.add(listImage);
    notifyListeners();
  }

  setListImageClear(){
    _listImage.clear();
    notifyListeners();
  }



  setDeleteListImage(int listImageIndex){
    _listImage.removeAt(listImageIndex);
    notifyListeners();
  }

  setItemName(String itemName){
    _itemName = itemName;
    notifyListeners();
  }

  setItemType(String itemType,int indexItemType){
    _itemType = itemType;
    _indexItemType = indexItemType;
    notifyListeners();
  }
  setItemCondition(String itemCondition){
    _itemCondition = itemCondition;

    notifyListeners();
  }
  setInformation(String information){
    _information = information;
    notifyListeners();
  }

  setDateAuction(String dateAuction){
    _dateAuction = dateAuction;
    notifyListeners();
  }

  setTimeAuction(String timeAuction){
    _timeAuction = timeAuction;
    notifyListeners();
  }

  setDateTimeAuction(String datetimeAuction){
    _datetimeAuction = datetimeAuction;
    notifyListeners();
  }

  setPlace(String place){
    _place = place;
    notifyListeners();
  }

  setPriceStart(String priceStart){
    _priceStart = priceStart;
    notifyListeners();
  }

  setPriceSmallest(String priceSmallest){
    _priceSmallest = priceSmallest;
    notifyListeners();
  }

  setPayThrough(String payThrough,int indexPayThrough){
    _payThrough = payThrough;
    _indexPayThrough = indexPayThrough;
    notifyListeners();
  }

  // setBankName(String bankName){
  //   _bankName = bankName;
  //   notifyListeners();
  // }
  //
  // setAccountName(String accountName){
  //   _accountName = accountName;
  //   notifyListeners();
  // }
  //
  // setAccountNumber(String accountNumber){
  //   _accountNumber = accountNumber;
  //   notifyListeners();
  // }
  //
  setDelivery(String delivery,int indexDelivery){
    _delivery = delivery;
    _indexDelivery = indexDelivery;
    notifyListeners();

  }
  //
  // setPlaceDelivery(String placeDelivery){
  //   _placeDelivery = placeDelivery;
  //   notifyListeners();
  // }
  //
  // setPhoneNumber(String phoneNumber){
  //   _phoneNumber = phoneNumber;
  //   notifyListeners();
  // }
  //
  // setMoreDetail(String moreDetail){
  //   _moreDetail = moreDetail;
  //   notifyListeners();
  // }

  setCtrlDateAuction(TextEditingController ctrlDateAuction){
    _ctrlDateAuction = ctrlDateAuction;
    notifyListeners();
  }

  setCtrlTimeAuction(TextEditingController ctrlTimeAuction){
    _ctrlTimeAuction = ctrlTimeAuction;

    notifyListeners();
  }

  setCtrlItemCondition(TextEditingController ctrlItemCondition){
    _ctrlItemCondition = ctrlItemCondition;
    notifyListeners();
  }

  setCtrlItemName(TextEditingController ctrlItemName){
    _ctrlItemName = ctrlItemName;
    notifyListeners();
  }

  setCtrlInformation(TextEditingController ctrlInformation){
    _ctrlInformation = ctrlInformation;
    notifyListeners();

  }

  setCtrlPriceStart(TextEditingController ctrlPriceStart){

    _ctrlPriceStart = ctrlPriceStart;
    notifyListeners();
  }

  setCtrlPriceSmallest(TextEditingController ctrlPriceSmallest){
    _ctrlPriceSmallest = ctrlPriceSmallest;
    notifyListeners();

  }

  /// Reset Data --------------------------------------------------------------------------------
  void resetState() {
    setListImageClear();
    setImageBig(null);
    setImageSmall1(null);
    setImageSmall2(null);
    setImageSmall3(null);
    setImageSmall4(null);
    setItemName('');
    setItemCondition('');
    // Provider.of<StoreReleaseBuddhistProvider>(context,listen:false).setBankName('');
    // Provider.of<StoreReleaseBuddhistProvider>(context,listen:false).setAccountName('');
    // Provider.of<StoreReleaseBuddhistProvider>(context,listen:false).setAccountNumber('');
    // Provider.of<StoreReleaseBuddhistProvider>(context,listen:false).setPlaceDelivery('');
    // Provider.of<StoreReleaseBuddhistProvider>(context,listen:false).setPhoneNumber('');
    // Provider.of<StoreReleaseBuddhistProvider>(context,listen:false).setMoreDetail('');
    setPriceStart('');
    setPriceSmallest('');
    setInformation('');
    setPayThrough('',-1);
    setDelivery('',-1);
    setItemType('',-1);
    setTimeAuction("");
    setDateAuction("");
    setDateTimeAuction("");
    if(ctrlItemName != null){
      ctrlItemName.clear();

    }
    if(ctrlItemCondition != null){
      ctrlItemCondition.clear();
    }
    if(ctrlPriceStart != null){
      ctrlPriceStart.clear();
    }
    if(ctrlPriceSmallest != null){
      ctrlPriceSmallest.clear();
    }
    if(ctrlInformation != null){
      ctrlInformation.clear();
    }

    if(ctrlDateAuction != null){
     ctrlDateAuction
          .clear();
    }
    if(ctrlTimeAuction != null){
      ctrlTimeAuction
          .clear();

    }

  }

  ///End Reset Data

  // setCtrlBankName(TextEditingController ctrlBankName){
  //
  //   _ctrlBankName = ctrlBankName;
  //   notifyListeners();
  //
  // }
  //
  // setCtrlAccountName(TextEditingController ctrlAccountName){
  //
  //   _ctrlAccountName = ctrlAccountName;
  //   notifyListeners();
  //
  // }
  //
  // setCtrlAccountNumber(TextEditingController ctrlAccountNumber){
  //
  //   _ctrlAccountNumber = ctrlAccountNumber;
  //   notifyListeners();
  //
  // }
  //
  // setCtrlPlaceDelivery(TextEditingController ctrlPlaceDelivery){
  //
  //   _ctrlPlaceDelivery = ctrlPlaceDelivery;
  //   notifyListeners();
  //
  // }
  //
  // setCtrlPhoneNumber(TextEditingController ctrlPhoneNumber){
  //
  //   _ctrlPhoneNumber = ctrlPhoneNumber;
  //   notifyListeners();
  //
  // }
  //
  // setCtrlMoreDetail(TextEditingController ctrlMoreDetail){
  //
  //   _ctrlMoreDetail = ctrlMoreDetail;
  //   notifyListeners();
  //
  // }




  /// Method PickerImage---------------------------------------------------


  Future<File> compressImage(String path) async{
    final newPath = p.join((await getTemporaryDirectory()).path,'${DateTime.now()}.${p.extension(path)}');
    final result = await FlutterImageCompress.compressAndGetFile(path, newPath,quality: 50,rotate: 0);
    return result;
  }

  Future imgFromCameraBig() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.camera,);

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

      maxWidth:600,
      maxHeight:800,
    );


    var file = await compressImage(croppedFile.path);
    print("croppedFile = ${croppedFile.lengthSync()}");
    print("file = ${file.lengthSync()}");




    if (pickedFile != null) {



      setListImage(file);
      setImageBig(file);
    } else {
      print('No image selected.');
    }

  }

  Future imgFromGalleryBig() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery,);

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
      maxWidth:600,
      maxHeight:800,
    );

    var file = await compressImage(croppedFile.path);
    print("croppedFile = ${croppedFile.lengthSync()}");
    print("file = ${file.lengthSync()}");



    if (pickedFile != null) {


      setListImage(file);
      setImageBig(file);

      print(imageBig.path);

    } else {
      print('No image selected.');
    }

  }

  Future imgFromCameraSmall1() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.camera);

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

      maxWidth:600,
      maxHeight:800,
    );

    var file = await compressImage(croppedFile.path);
    print("croppedFile = ${croppedFile.lengthSync()}");
    print("file = ${file.lengthSync()}");

    if (pickedFile != null) {

      setListImage(file);
      setImageSmall1(file);
    } else {
      print('No image selected.');
    }

  }

  Future imgFromGallerySmall1() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

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

      maxWidth:600,
      maxHeight:800,
    );

    var file = await compressImage(croppedFile.path);
    print("croppedFile = ${croppedFile.lengthSync()}");
    print("file = ${file.lengthSync()}");

    if (pickedFile != null) {
      setListImage(file);
      setImageSmall1(file);
    } else {
      print('No image selected.');
    }

  }

  Future imgFromCameraSmall2() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.camera);
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

      maxWidth:600,
      maxHeight:800,
    );
    var file = await compressImage(croppedFile.path);
    print("croppedFile = ${croppedFile.lengthSync()}");
    print("file = ${file.lengthSync()}");
    if (pickedFile != null) {

      setListImage(file);
      setImageSmall2(file);
    } else {
      print('No image selected.');
    }

  }

  Future imgFromGallerySmall2() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
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

      maxWidth:600,
      maxHeight:800,
    );
    var file = await compressImage(croppedFile.path);
    print("croppedFile = ${croppedFile.lengthSync()}");
    print("file = ${file.lengthSync()}");
    if (pickedFile != null) {

      setListImage(file);
      setImageSmall2(file);
    } else {
      print('No image selected.');
    }

  }

  Future imgFromCameraSmall3() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.camera);
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

      maxWidth:600,
      maxHeight:800,
    );

    var file = await compressImage(croppedFile.path);
    print("croppedFile = ${croppedFile.lengthSync()}");
    print("file = ${file.lengthSync()}");

    if (pickedFile != null) {

      setListImage(file);
      setImageSmall3(file);
    } else {
      print('No image selected.');
    }

  }

  Future imgFromGallerySmall3() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
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

      maxWidth:600,
      maxHeight:800,
    );
    var file = await compressImage(croppedFile.path);
    print("croppedFile = ${croppedFile.lengthSync()}");
    print("file = ${file.lengthSync()}");
    if (pickedFile != null) {

      setListImage(file);
      setImageSmall3(file);
    } else {
      print('No image selected.');
    }

  }

  Future imgFromCameraSmall4() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.camera);
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

      maxWidth:600,
      maxHeight:800,
    );
    var file = await compressImage(croppedFile.path);
    print("croppedFile = ${croppedFile.lengthSync()}");
    print("file = ${file.lengthSync()}");
    if (pickedFile != null) {

      setListImage(file);
      setImageSmall4(file);
    } else {
      print('No image selected.');
    }

  }

  Future imgFromGallerySmall4() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
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

      maxWidth:600,
      maxHeight:800,
    );
    var file = await compressImage(croppedFile.path);
    print("croppedFile = ${croppedFile.lengthSync()}");
    print("file = ${file.lengthSync()}");
    if (pickedFile != null) {

      setListImage(file);
      setImageSmall4(file);
    } else {
      print('No image selected.');
    }

  }


///End Method PickerImage///////////////////////////////////////////////////


}