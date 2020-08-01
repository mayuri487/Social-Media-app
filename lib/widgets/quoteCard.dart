import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteCard extends StatelessWidget {

  final String quote;
  final String userId;
  final int likes;

  QuoteCard(this.quote, this.userId, this.likes);

  @override
  Widget build(BuildContext context) {
    return Container(
          width: double.infinity,
          height: 135.0,
          child: Card(
            elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(quote, 
                    style: TextStyle(
                      fontSize: 20
                    )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder(
                          future: Firestore.instance.collection('profile')
                          .document(userId).get(),
                          builder: (ctx, snapShot){
                            if(snapShot.connectionState == ConnectionState.waiting){
                              return CircleAvatar(
                                radius: 20,
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                           final image = snapShot.data['profile_photo'];
                            return CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(image),
                            );
                          },
                        ),
                        // CircleAvatar(
                        //   radius: 20,

                        // ),
                        Container(
                            child: Row(
                          children: [
                            IconButton(icon: Icon(Icons.star), onPressed: () {}),
                            Text(likes.toString())
                          ],
                        )),
                        IconButton(icon: Icon(Icons.share), onPressed: () {})
                      ],
                    ),
                  )
                ],
              )));
  }
}