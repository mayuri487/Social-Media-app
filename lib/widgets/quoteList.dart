import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/userQuoteCard.dart';

class QuoteList extends StatelessWidget {
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
                    .collection('user_quotes/$user/quotes')
                    .snapshots(),
                builder: (ctx, snapShots) {
                  if (snapShots.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final quoteSnap = snapShots.data.documents;

                  return ListView.builder(
                    itemCount: quoteSnap.length,
                    itemBuilder: (ctx, index) {
                      return UserQuoteCard(
                          quoteSnap[index]['quote'], quoteSnap[index]['likes']);
                    },
                  );
                },
              );
            })
            );
  }
}
