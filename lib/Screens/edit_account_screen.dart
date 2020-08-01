import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../Screens/account_screen.dart';

class EditAccountScreen extends StatefulWidget {
  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  bool _isLoading = false;
  final _form = GlobalKey<FormState>();

  var profilePic;
  String userName;
  String bio;
  String riderName;
  String rideName;

  @override
  void initState() {
    setProfile();
    super.initState();
  }

  void setProfile() async {
    setState(() {
      _isLoading = true;
    });

    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('profile').document(user.uid).get();
    setState(() {
      userName = userData['userName'];
      bio = userData['bio'];
      riderName = userData['riderName'];
      rideName = userData['rideName'];
      profilePic = userData['profile_photo'];
    });
    setState(() {
      _isLoading = false;
    });
  }

  void _updateData() async {
    _form.currentState.save();
    final user = await FirebaseAuth.instance.currentUser();

    Firestore.instance.collection('profile').document(user.uid).updateData({
      'userName': userName,
      'rideName': rideName,
      'riderName': riderName,
      'bio': bio,
      'profile_photo': profilePic
    });
    Firestore.instance
        .collection('user')
        .document(user.uid)
        .updateData({'userName': userName, 'image_url': profilePic});
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text('Edit Profile')),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profilePic),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Change Profile Photo'),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _form,
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: userName,
                            decoration: InputDecoration(labelText: 'Username'),
                            onSaved: (value) {
                              userName = value;
                            },
                          ),
                          TextFormField(
                            initialValue: bio,
                            decoration: InputDecoration(labelText: 'Bio'),
                            onSaved: (value) {
                              bio = value;
                            },
                          ),
                          TextFormField(
                            initialValue: riderName,
                            decoration: InputDecoration(labelText: 'RiderName'),
                            onSaved: (value) {
                              riderName = value;
                            },
                          ),
                          TextFormField(
                            initialValue: rideName,
                            decoration: InputDecoration(labelText: 'RideName'),
                            onSaved: (value) {
                              rideName = value;
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 150),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      child: RaisedButton(
                        onPressed: _updateData,
                        child: Text('Save'),
                      ),
                    ),
                  )
                ],
              ));
  }
}
