import 'package:firebase_database/firebase_database.dart';

class ServiceStream{

  static updateInboxReadRealtime(int id,int sendBy,String key,bool isMe){

    if(isMe == false) {
      DatabaseReference _databaseReference2 = FirebaseDatabase.instance
          .reference()
          .child('chat_room/$id/$key/read');
      _databaseReference2.set(1);
    }


  }

  //Stream For Price And User Auction
  static Stream<Event> inboxRealtime(int id) {
    DatabaseReference _databaseReference = FirebaseDatabase.instance
        .reference()
        .child('chat_room/$id');
    return _databaseReference.onValue;
  }

  //Stream For Price And User Auction
 static Stream<Event> priceRealtime(int id) {
    DatabaseReference _databaseReference = FirebaseDatabase.instance
        .reference()
        .child('buddhist')
        .child("$id");
    return _databaseReference.onValue;
  }
 //Stream For Comment Count
 static Stream<Event> commentRealtime(int idBuddhist) {
   DatabaseReference _databaseReference = FirebaseDatabase.instance
       .reference()
       .child('Comments')
       .child('${idBuddhist.toString()}');

   return _databaseReference.onValue;
 }

 static Stream<Event> orderComment(int idBuddhist) {
  Query _databaseReference = FirebaseDatabase.instance
      .reference()
      .child('Comments/$idBuddhist');


  return _databaseReference.onValue;
}


 static Stream<Event> bidder(int idBuddhist) {
   Query _databaseReference = FirebaseDatabase.instance
       .reference()
       .child('buddhist/$idBuddhist');
   return _databaseReference.onValue;
 }

 static Stream<Event> lastBidder(int idBuddhist) {
   Query _databaseReference = FirebaseDatabase.instance
       .reference()
       .child('buddhist/$idBuddhist').limitToLast(1);

   return _databaseReference.onValue;
 }
}