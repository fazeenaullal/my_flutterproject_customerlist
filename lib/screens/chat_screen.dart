import 'dart:developer';
import 'dart:io';

import 'package:customer_list/Services/firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:customer_list/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  static const String id= 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textController=TextEditingController();
  final TextEditingController textController4=TextEditingController();
  final TextEditingController textController1=TextEditingController();
  final TextEditingController textController2=TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FireStoreService fs=FireStoreService();
  List customerList=[];
  List results=[];
  late Future resultLoaded;
  File? galleryFile;
  final picker = ImagePicker();
  String imageUrl = '';
 //searchbar code
  @override
  void initState() {
    _searchController.addListener(onSearch);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _searchController.removeListener(onSearch);
    _searchController.dispose();
       super.dispose();
  }


  @override
  void didChangeDependencies() {
    resultLoaded=getNotesFromDB();
    super.didChangeDependencies();
  }

  onSearch(){
    searchResultList();
    print(_searchController.text);
  }

  searchResultList(){
    var showResult=[];
    if(_searchController.text!=""){
showResult=customerList.where((user) => user["name"].toLowerCase().contains(_searchController.text.toLowerCase())
    || user["billno"].toString().contains(_searchController.text.toLowerCase())).toList();
    }else{
      // final result = jobProvider.where((a) => a.categoryName.toLowerCase().contains(query)
      //     || a.categoryId.toLowerCase().contains(query));
      // showResult=List.from(customerList);
    }
    setState(() {
      results=showResult;
    });
  }

 getNotesFromDB() async {
    var data=await FirebaseFirestore.instance.collection('message').get();
    setState(() {
      // customerList=data.docs.map((doc) => doc.data()).toList();
      customerList=data.docs;
    });
    searchResultList();
      }
//searchbar code ends

//image picker code
  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
      ImageSource img,
      ) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file =
    await imagePicker.pickImage(source: img);
    print('${file?.path}');

    if (file == null) return;
    //Import dart:core
    String uniqueFileName=DateTime.now().millisecondsSinceEpoch.toString();

    /*Step 2: Upload to Firebase storage*/
    //Install firebase_storage
    //Import the library

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    //Create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(File(file!.path));
      //Success: get the download URL
      imageUrl = await referenceImageToUpload.getDownloadURL();


    } catch (error) {
      //Some error occurred
    }

    // final pickedFile = await picker.pickImage(source: img);
    // XFile? xfilePick = pickedFile;
    //
    //     if (xfilePick != null) {
    //       galleryFile = File(pickedFile!.path);
    //     } else {
    //       ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
    //           const SnackBar(content: Text('Nothing is selected')));
    //     }

  }


  void openNoteBox({String? docId, String? cname,String? citem,String? cno}){
    // if(docId==null||cname==null) {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              content: Form(

                child: Column(
                  children: [
                    TextField(
                      controller: textController,
                      decoration: InputDecoration(
                          hintText: 'Enter Customer Name'),
                    ),
                    TextField(
                      controller: textController1,
                      decoration: InputDecoration(
                          hintText: 'Enter order details'),
                    ),
                    TextField(
                      controller: textController2,
                      decoration: InputDecoration(
                          hintText: 'Enter billNo'),
                    ),
                    ElevatedButton(style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.green)),
                        child: const Text('choose photos'),
                        onPressed:() {
                          _showPicker(context: context);
                        },),
                    const SizedBox(
                      height: 20,
                    ),
                    // SizedBox(
                    //   height: 200.0,
                    //   width: 300.0,
                    //   child: galleryFile == null
                    //       ? const Center(child: Text('Sorry nothing selected!!'))
                    //       : Center(child: Image.file(galleryFile!)),
                    // ),
                    ElevatedButton(onPressed: () {
                      if (imageUrl.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Please upload an image')));

                        return;
                      }

                      // if (key.currentState!.validate()) {
                        //   String itemName = _controllerName.text;
                        //   String itemQuantity = _controllerQuantity.text;
                        //
                        //   //Create a Map of data
                        //   Map<String, String> dataToSend = {
                        //     'name': itemName,
                        //     'quantity': itemQuantity,
                        //     'image': imageUrl,
                        //   };
                        //
                        //   //Add a new item
                        //   _reference.add(dataToSend);
                        // }

                        if (textController.text.isNotEmpty &&
                            textController1.text.isNotEmpty &&
                            textController2.text.isNotEmpty) {
                          if (docId == null) {
                            fs.addNotes(
                                textController.text, textController1.text,
                                textController2.text, imageUrl,
                                context);
                          } else {
                            fs.UpdateNotes(docId, textController.text,
                                textController1.text, textController2.text,
                                context);
                            showDialog(context: context, builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    "Updated all your data"
                                ),


                              );
                            });
                          }
                        } else {
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(
                              title: Text(
                                  "Please enter all your data"
                              ),


                            );
                          });
                        }

                        // ,textController1.text);//this is to add
                        //clear
                        textController.clear();
                        textController1.clear();
                        textController2.clear();
                        //close
                        Navigator.pop(context);

                    }, child: Text('SAVE'))
                  ],
                ),
              ),

            ),
      );

  }

  final _auth=FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                // getMessages();
                _auth.signOut();
                Navigator.pop(context);//Implement logout functionality
              }),
        ],
        title: Text('Customer List'),
        // title: TextField(
        //   controller: _searchController,
        //   style: const TextStyle(color: Colors.white),
        //   cursorColor: Colors.white,
        //   decoration: const InputDecoration(
        //     hintText: 'CustomerList',
        //     hintStyle: TextStyle(color: Colors.white54),
        //     border: InputBorder.none,
        //   ),
        //   onChanged: (value) {
        //     // Perform search functionality here
        //   },
        // ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),

      body:Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              // onChanged: (value) => runFilter(value),
              decoration: InputDecoration(
                contentPadding:const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                hintText: "Search for Name or BillNo",
                suffixIcon: const Icon(Icons.search),
                // prefix: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
Expanded(child:
              // child: StreamBuilder<QuerySnapshot>(
              //   stream:getNotesFromDB(),
              //   builder:(context,snapshot){
              //     if(snapshot.hasData){
              //       List customerList=snapshot.data!.docs;
                    //display
                    // return SingleChildScrollView(
                       ListView.builder(

                        shrinkWrap: true,
                        itemCount:results.length,
                        itemBuilder: (context,index){
                          //get each doc
                          DocumentSnapshot document=results[index];
                          String docId=document.id;
                          String cname=results[index]['name'];
                          String citem=results[index]['item'];
                          String cno=results[index]['billno'];
                      
                          //get message from each doc
                          Map<String,dynamic> data=document.data() as Map<String,dynamic>;
                      
                          String CustomerName=data['name'];
                          String order=data['item'];
                          String number=data['billno'];
                      
                          //display as list tile
                           return ListTile(
                      
                      
                               title:
                             Column(
                      
                                 children: <Widget>[
                                   Text(CustomerName),
                                   Text(order),
                                   Text(number),
                                   Container(
                                     // height: 80,
                                     // width: 80,
                                     child: InteractiveViewer(
                                       boundaryMargin: EdgeInsets.all(20.0),
                                       minScale: 0.1,
                                       maxScale: 1.6,
                                     child: data.containsKey('image') ? Image.network('${data['image']}') : Container(),
                                   ),)
                             ],
                             ),
                             trailing: Row(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 IconButton(
                                   onPressed: (){
                                     textController.text=cname;
                                     textController1.text=citem;
                                     textController2.text=cno;
                                     openNoteBox(docId: docId,cname: cname,citem:citem,cno:cno);
                      
                                   },
                                     icon: const Icon(Icons.settings),

                      
                                 ),
                                 IconButton(
                                   onPressed:() => fs.deleteNotes(docId,context),
                                   icon: const Icon(Icons.delete),
                      
                                 ),
                               ],
                             ),
                           );
                        },
                      ),
                    )

          ],
        ),
      ),


      );

  }
}
