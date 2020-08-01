import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Creates list of video players
class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  final _controller = TextEditingController();

  var enteredUrl = '';
  var enteredTitle = '';

  void _addVideo() async {
    final currentUser = await FirebaseAuth.instance.currentUser();

    Firestore.instance
        .collection('user_video')
        .document(currentUser.uid)
        .collection('videos')
        .add({
      'title': enteredTitle,
      'videoUrl': enteredUrl,
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (ctx, userSnap) {
            if (userSnap.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            final user = userSnap.data.uid;

            return StreamBuilder(
              stream: Firestore.instance
                  .collection('user_video/$user/videos')
                  .snapshots(),
              builder: (ctx, snapShots) {
                if (snapShots.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final videoSnap = snapShots.data.documents;

                return ListView.separated(
                  itemCount: videoSnap.length,
                  separatorBuilder: (context, _) => Divider(),
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: YoutubePlayer(
                            controller: YoutubePlayerController(
                              initialVideoId: YoutubePlayer.convertUrlToId(
                                videoSnap[index]['videoUrl'],
                              ),
                              flags: YoutubePlayerFlags(
                                autoPlay: false,
                                mute: false,
                              ),
                            ),
                            showVideoProgressIndicator: true,
                          ),
                        ),
                        Text(videoSnap[index]['title'])
                      ],
                    );
                  },
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  content: Container(
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              enteredTitle = value;
                            });
                          },
                          decoration: InputDecoration(labelText: 'Video Name'),
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Video Url'),
                          onChanged: (value) {
                            setState(() {
                              enteredUrl = value;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  actions: [
                    RaisedButton(
                      onPressed: 
                      // enteredUrl.trim().isEmpty &&
                      //         enteredTitle.trim().isEmpty
                      //     ? null
                           _addVideo,
                      child: Text('Add'),
                    )
                  ],
                );
              },
            );
          },
          child: Icon(Icons.add)),
    );
  }
}
