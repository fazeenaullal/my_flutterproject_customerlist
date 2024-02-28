
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService{
  User? user=FirebaseAuth.instance.currentUser;
  //get collection of customer details
final CollectionReference message=FirebaseFirestore.instance.collection('message');
  //create
  Future<void> addNotes(String notes,String email){
    return message.add({
      'sender': email,
      'text' : notes,
      // 'timestamp':TimeStamp.now(),
    });
}
  //read
  Stream<QuerySnapshot> getNotesFromDB() {
    final messageStream = message.snapshots();
    return messageStream;
}
  //update

  //delete
}