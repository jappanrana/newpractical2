import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newpractical2/user_screen.dart';
import 'package:newpractical2/users.dart';

class EditUser extends StatefulWidget {
  String userId;
  EditUser({Key? key,required this.userId}) : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState(userId);
}

class _EditUserState extends State<EditUser> {
  //key
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  //controller
  final userNameController = TextEditingController();

  //firebase initiate
  final storeUser = FirebaseFirestore.instance.collection("users");

  //variables
  String imageUrl = " ";
  String userName = " ";
  String userId;
  _EditUserState(this.userId);

  //functions
  void pickUploadImage(String name) async{
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 75
    );
    Reference ref = FirebaseStorage.instance.ref().child(name+".jpg");

    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) => {
      setState((){
        imageUrl = value;
      })
    });
  }

  void readUser() async{
    final docUser = storeUser.doc(userId);
    final snapshot = await docUser.get();

    if(snapshot.exists){
      User user = User.fromJson(snapshot.data()!);
      setState(() {
        userName = user.name;
        imageUrl = user.image;
        userNameController.text = userName;
      });
    }
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    if(userId != ''){
      readUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(0, 46, 0, 0),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Spacer(),
                    InkWell(
                      onTap: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const UserScreen()),)
                      },
                      child: Text("View All ",style: TextStyle(fontSize: 20),),
                    )
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(top: 80),
                      width: 120,
                      height: 120,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Center(
                        child: imageUrl == " " ?
                        Icon(Icons.person,size: 80,) :
                        Image.network(imageUrl),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  controller: userNameController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    counterText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    hintText: "User Name",
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Spacer(),
                    ElevatedButton(
                        onPressed: (){
                          if(userNameController.text.toString() != ""){
                            pickUploadImage(userNameController.text.toString());
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              elevation: 100,
                              content: Text("Write Username First"),
                            ));
                          }
                        },
                        child: Container(
                          child: Text("Upload"),
                        )
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Spacer(),
                    ElevatedButton(
                        onPressed: () async{
                          if(imageUrl != " "){
                            User user = User(
                              name: userNameController.text.toString(),
                              image: imageUrl,
                            );
                            final docUser = storeUser.doc(userId);
                            user.id = userId;
                            final userObjjson = user.toJson();
                            await docUser.set(userObjjson);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const UserScreen()),);
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              elevation: 100,
                              content: Text("Username Or Image Missing"),
                            ));
                          }
                        },
                        child: Container(
                          child: Text("Save"),
                        )
                    ),
                    Spacer(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
