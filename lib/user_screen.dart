import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:newpractical2/edit_user.dart';
import 'package:newpractical2/users.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

enum ScreenCurrentState{
  SHOW_DEFAULT_STATE
}

class _UserScreenState extends State<UserScreen> {
  //key
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  //controller

  //firebase initiate
  final storeUser = FirebaseFirestore.instance.collection("users");

  //variables

  //to get widgets
  Widget buildUser(User user) => Slidable(
      child: ListTile(
        leading: CircleAvatar(child: Image.network(user.image)),
        title: Text(user.name),
      ),
    startActionPane: ActionPane(
      motion: StretchMotion(),
      children: [
        SlidableAction(
            onPressed: ((context) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditUser(userId: user.id)),);
            }),
            backgroundColor: Colors.blue,
            icon: Icons.edit,
        )
      ],
    ),
    endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            onPressed: ((context) {
              final docUser = FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.id);
              docUser.delete();
            }),
            backgroundColor: Colors.red,
            icon: Icons.delete,
          )
        ]
    ),
  );

  Stream<List<User>> readUsers () => storeUser
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => User.fromJson(doc.data())).toList()
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: StreamBuilder(
        stream: readUsers(),
        builder: (context, snapshot){
          if(snapshot.hasData) {
            final users = snapshot.data!;
            return ListView(
              children: users.map(buildUser).toList(),
            );
          }else{
            print(snapshot);
            return Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }
}
