
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService{
  User? user=FirebaseAuth.instance.currentUser;
  //get collection of customer details
final CollectionReference message=FirebaseFirestore.instance.collection('message');
  //create
  Future<void> addNotes(String email,String notes,String number){
    return message.add({
      'customername': email,
      'customerorder' : notes,
      'phoneno':number,

    });
}
  //read
  Stream<QuerySnapshot> getNotesFromDB() {
    final messageStream = message.snapshots();
    return messageStream;
}
  //update
Future<void> UpdateNotes(String docId,String newName,String newOrder,String newNumber){
return message.doc(docId).update({
  'customername': newName,
  'customerorder' : newOrder,
  'phoneno':newNumber,
});
}
  //delete
Future<void> deleteNotes(String docId){
    return message.doc(docId).delete();
}
}