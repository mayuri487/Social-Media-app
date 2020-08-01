import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/quoteCard.dart';

class HomePageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('UrbanRider'),
          backgroundColor: Colors.red,
          actions: [
            DropdownButton(
              icon: Icon(Icons.more_vert,
                  color: Theme.of(context).primaryIconTheme.color),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 8),
                        Text('Log out')
                      ],
                    ),
                  ),
                  value: 'logOut',
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logOut') {
                  FirebaseAuth.instance.signOut();
                }
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('quotes').snapshots(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            final quoteSnap = streamSnapshot.data.documents;
            return ListView.builder(
              itemCount: quoteSnap.length,
              itemBuilder: (ctx, index) {
                return QuoteCard(
                  quoteSnap[index]['quote'],
                  quoteSnap[index]['userId'],
                  quoteSnap[index]['likes']
                );
              },
            );
          },
        ));
  }
}
