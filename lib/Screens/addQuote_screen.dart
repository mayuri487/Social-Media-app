import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddQuoteScreen extends StatefulWidget {
  @override
  _AddQuoteScreenState createState() => _AddQuoteScreenState();
}

class _AddQuoteScreenState extends State<AddQuoteScreen> {
  final controller = TextEditingController();
  var enteredQuote = '';

  void _addQuote() async {
    final user = await FirebaseAuth.instance.currentUser();

    Firestore.instance.collection('quotes').document(user.uid).setData({
      'userId': user.uid,
      'quote': enteredQuote,
      'likes': 0
    });
     controller.clear();
     Firestore.instance.collection('user_quotes').document(user.uid).collection('quotes').add({
       'quote': enteredQuote,
       'likes': 0,
     });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Quote'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Column(
          children: [
            TextField(
              controller: controller,
              onChanged: (value) {
                setState(() {
                   enteredQuote = value;
                });
               
              },
            ),
            SizedBox(height: 20),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: enteredQuote.trim().isEmpty ? null : _addQuote,
            )
          ],
        )),
      ),
    );
  }
}
