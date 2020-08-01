import 'package:flutter/material.dart';

import '../Screens/account_screen.dart';
import '../Screens/addQuote_screen.dart';
import '../Screens/homePage_screen.dart';

class TabsScreen extends StatefulWidget {

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Widget> _pages =[
    HomePageScreen(),
    AddQuoteScreen(),
    ProfileScreen(),
  ];

  var _selectedPageIndex = 0 ;

  void _selectPage(int index){
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title:Text('Brand Name')
      // ),
      body: _pages[_selectedPageIndex],
       bottomNavigationBar: BottomNavigationBar(
         selectedItemColor: Colors.red,
         unselectedItemColor: Colors.grey,
         currentIndex: _selectedPageIndex,
         onTap: _selectPage,
         items: [
         BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('home')),
           BottomNavigationBarItem(icon: Icon(Icons.edit), title: Text('edit')),
             BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('account')),
       ]),
    );
  }
}