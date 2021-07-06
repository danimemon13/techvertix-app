import 'package:flutter/material.dart';

class tabs extends StatefulWidget {
  @override
  _tabsState createState() => _tabsState();
}

class _tabsState extends State<tabs> {
  int selectedIndex = 0;
  final List<String> categories = ['Messages', 'Contacts', 'Groups'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.0,
      color: Colors.cyan,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 30.0,
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: index == selectedIndex ? Colors.white : Colors.white60,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
