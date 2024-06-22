import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchData extends SearchDelegate{
  final CollectionReference message=FirebaseFirestore.instance.collection('message');
  @override
  List<Widget>? buildActions(BuildContext context) {

  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
   return StreamBuilder<QuerySnapshot>(
         stream:message.snapshots().asBroadcastStream(),
         // builder:(context,snapshot){
       builder:(BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
           if(snapshot.hasData){
             // List customerList=snapshot.data!.docs;
             //display
             // return ListView.builder(
             //   itemCount:customerList.length,
             //   itemBuilder: (context,index){
             //     //get each doc
             //     DocumentSnapshot document=customerList[index];
             //     String docId=document.id;
             //
             //     //get message from each doc
             //     Map<String,dynamic> data=document.data() as Map<String,dynamic>;
             //
             //     String CustomerName=data['customername'];
             //     String order=data['customerorder'];
             //     String number=data['phoneno'];
             //
             //     //display as list tile
             //      return ListTile(
             //
             //
             //          title:
             //        Column(
             //
             //            children: <Widget>[
             //              Text(CustomerName),
             //              Text(order),
             //              Text(number),
             //        ],
             //        ),
             //        trailing: Row(
             //          mainAxisSize: MainAxisSize.min,
             //          children: [
             //            IconButton(
             //              onPressed:() => openNoteBox(docId: docId),
             //              icon: const Icon(Icons.settings),
             //
             //            ),
             //            IconButton(
             //              onPressed:() => fs.deleteNotes(docId),
             //              icon: const Icon(Icons.delete),
             //
             //            ),
             //          ],
             //        ),
             //      );
             //   },
             // );
             return ListView(
               children: [
                 ...snapshot.data!.docs.where
                   ((QueryDocumentSnapshot<Object?> element) => element['name']
                     .toString().toLowerCase()
                     .contains(query.toLowerCase())).map((QueryDocumentSnapshot<Object?> data){
        final String CustomerName=data['name'];
           final  String order=data['item'];
        final String number=data['billno'];
        return ListTile(

        );

                 })
               ],
             );
           }else{
             return const Text("no data to view...");
           }
         }
       );

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
  
}