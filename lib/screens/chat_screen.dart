import 'dart:developer';

import 'package:customer_list/Services/firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:customer_list/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String id= 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textController=TextEditingController();
  final TextEditingController textController1=TextEditingController();
  final FireStoreService fs=FireStoreService();
  void openNoteBox(){
    showDialog(
        context: context,
        builder: (context)=>AlertDialog(
          content: Form(

            child: Column(
              children: [
                TextField(
                  controller:textController,
                  decoration: InputDecoration(hintText: 'Enter text'),
                ),
                TextField(
                  controller:textController1,
                  decoration: InputDecoration(hintText: 'Enter text'),
                ),
                ElevatedButton(onPressed: () {
                  fs.addNotes(textController.text,textController1.text);
                  // ,textController1.text);//this is to add
                  //clear
                  textController.clear();
                  textController1.clear();
                  //close
                  Navigator.pop(context);
                }, child: Text('SAVE'))
              ],
            ),
          ),
         
        ),
    );
  }
//   late String messageText;
//
  final _auth=FirebaseAuth.instance;
// final _firestore=FirebaseFirestore.instance;
//
//   @override
//   void initState() {
//
//     super.initState();
//
//     getCurrentUser();
//   }
//
//  void getCurrentUser() async{
//     try{
//       final User? user = _auth.currentUser;
//   // final user=_auth.currentUser;
//   if(user!=null){
//     final uid = user.email;
//     print(uid);
//   }
//   }catch(e){
//       print(e);
//   }
// }
//
// void getMessages() async{
//     final message=await _firestore.collection('message').snapshots();
//
//     for(var messages in message.){
//       print(messages.data);
//     }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // getMessages();
                _auth.signOut();
                Navigator.pop(context);//Implement logout functionality
              }),
        ],
        // title: Text('⚡️Chat'),
        title: Text('Customers_Details'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:fs.getNotesFromDB(),
        builder:(context,snapshot){
          if(snapshot.hasData){
            List customerList=snapshot.data!.docs;
            //display
            return ListView.builder(
              itemCount:customerList.length,
              itemBuilder: (context,index){
                //get each doc
                DocumentSnapshot document=customerList[index];
                String docId=document.id;

                //get message from each doc
                Map<String,dynamic> data=document.data() as Map<String,dynamic>;

                String CustomerName=data['text'];
                String order=data['sender'];

                //display as list tile
                 return ListTile(
                   title:Text(CustomerName),
                     subtitle:Text(order),
                 );
              },
            );
          }else{
            return const Text("no data");
          }
        }
      ),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     crossAxisAlignment: CrossAxisAlignment.stretch,
      //     children: <Widget>[
      //       Container(
      //         decoration: kMessageContainerDecoration,
      //         child: Row(
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: <Widget>[
      //             Expanded(
      //               child: TextField(
      //                 onChanged: (value) {
      //                  messageText=value;
      //                 },
      //                 decoration: kMessageTextFieldDecoration,
      //               ),
      //             ),
      //             TextButton (
      //               onPressed: () {
      //                 _firestore.collection('message').add({'text':messageText,'sender':'husain@gmail.com'});
      //               },//Implement send functionality.
      //               child: Text(
      //                 'Send',
      //                 style: kSendButtonTextStyle,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
