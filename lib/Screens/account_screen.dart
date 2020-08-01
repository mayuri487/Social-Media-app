import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:urbanrider_taskchallenge/widgets/video_list.dart';
import '../widgets/quoteList.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;

  final appBar = AppBar(
    backgroundColor: Colors.red,
    elevation: 0,
    title: Text(
      'Brand name',
      style: TextStyle(
        fontSize: 20.0,
      ),
    ),
  );

  @override
  void initState() {
    setProfile();
    super.initState();
  }

  var image;
  int follower;
  int following;
  String userName;
  String bio;
  String rideName;
  String riderName;


  void setProfile() async {
    setState(() {
      _isLoading = true;
    });

    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('profile').document(user.uid).get();
    setState(() {
      image = userData['profile_photo'];
      follower = userData['follower'];
      following = userData['folowing'];
      userName = userData['userName'];
      bio = userData['bio'];
      rideName = userData['rideName'];
      riderName = userData['riderName'];
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final availableHeight = (MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top);

    return Scaffold(
      appBar: appBar,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                      height: availableHeight * 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 110.0,
                                  height: 110.0,
                                  child: CircleAvatar(
                                      backgroundImage: image == null
                                          ? CircularProgressIndicator()
                                          : NetworkImage(image)),
                                ),
                                SizedBox(width: 25.0),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                follower.toString(),
                                                style: TextStyle(
                                                    fontSize: 24.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'followers',
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                following.toString(),
                                                style: TextStyle(
                                                    fontSize: 24.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'following',
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15.0),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Material(
                                              elevation: 1,
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0)),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  Navigator.of(context).pushNamed('/editaccountScreen');
                                                },
                                                child: Text('Edit Account',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8.0),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(userName)
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(bio),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(rideName),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(riderName),
                              )
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Divider(),
                  ),
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              border: BorderDirectional(
                                  bottom: BorderSide(color: Colors.grey[800]))),
                          child: SafeArea(
                            child: Column(
                              children: <Widget>[
                                TabBar(
                                  indicatorColor: Colors.grey,
                                  tabs: <Widget>[
                                    Tab(
                                      icon: Icon(
                                        Icons.video_library,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Tab(
                                      icon: Icon(Icons.message,
                                          color: Colors.black),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.grey,
                          height: MediaQuery.of(context).size.height * 0.44,
                          child: TabBarView(
                            children: <Widget>[
                              // Tab1
                              //  Container(
                              //       height: availableHeight * 0.6,
                              //       child: Text('Add videos')),
                              VideoList(),

                              // Container(
                              //   height: availableHeight * 0.6,
                              //   child: Text('Add quotes'),
                              // ),
                              QuoteList()

                              // Tab2
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
      // floatingActionButton: FloatingActionButton(onPressed: (){},
      // child: Icon(Icons.add),
    );
  }
}
