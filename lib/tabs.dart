import 'package:flutter/material.dart';


class tabsTest extends StatefulWidget {
  @override
  _tabsTestState createState() => _tabsTestState();
}

class _tabsTestState extends State<tabsTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ""
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.chat_bubble_sharp)),
                Tab(icon: Icon(Icons.contact_page_sharp)),
                Tab(icon: Icon(Icons.call)),
              ],
            ),
            title: Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: [
              Icon(Icons.flight, size: 350),
              Icon(Icons.directions_transit, size: 350),
              Icon(Icons.directions_car, size: 350),
            ],
          ),
        ),
      )
      ,
    );
  }
}
