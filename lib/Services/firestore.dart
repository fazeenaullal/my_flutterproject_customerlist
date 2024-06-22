
import 'package:customer_list/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreService{
  User? user=FirebaseAuth.instance.currentUser;
  //get collection of customer details
final CollectionReference message=FirebaseFirestore.instance.collection('message');
  //create
  void addNotes(String email,String notes,String number,String imageUrl,context) async {

    await message.add({
      'name': email,
      'item' : notes,
      'billno':number,
      'image':imageUrl,

    });
    Navigator.push(context, MaterialPageRoute(builder:(context)=>ChatScreen()));
     showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text(
            "Successfully saved your data"
        ),


      );
     });
}
  //read
//   Stream<QuerySnapshot> getNotesFromDB() {
//     final messageStream = message.snapshots();
//     return messageStream;
// }
  //update
void UpdateNotes(String docId,String newName,String newOrder,String newNumber,context) async{
await message.doc(docId).update({
  'name': newName,
  'item' : newOrder,
  'billno':newNumber,
});
Navigator.push(context, MaterialPageRoute(builder:(context)=>ChatScreen()));
showDialog(context: context, builder: (context){
  return AlertDialog(
    title: Text(
        "Successfully updated your data"
    ),


  );
});
}
  //delete
void deleteNotes(String docId,context) async{
    await message.doc(docId).delete();
    Navigator.push(context, MaterialPageRoute(builder:(context)=>ChatScreen()));
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text(
            "Successfully deleted your data"
        ),


      );
    });
}

//getting data to searchbar
// List _allResault = [];
//   getCustomername() async{
//     var data = await FirebaseFirestore.instance.collection('message').orderBy('customername').get();
//     setState((){
//       _allResault = data.docs;
//     });
//   }
//   Future<void> runFilter(String enteredKeyword)async {

  //   List<Map<String, dynamic>> results = [];
  //   if (enteredKeyword.isEmpty) {
  //     // if the search field is empty or only contains white-space, we'll display all users
  //     results = message.snapshots() as List<Map<String, dynamic>>;
  //   } else {
  //     results = message.snapshots()
  //         .where((message) =>
  //         message['name'].toLowerCase().contains(enteredKeyword.toLowerCase()))
  //         .toList() as List<Map<String, dynamic>>;
  //     // we use the toLowerCase() method to make it case-insensitive
  //   }
  //
  //   // Refresh the UI
  //   setState(() {
  //     _foundUsers = results;
  //   });
  // }

}