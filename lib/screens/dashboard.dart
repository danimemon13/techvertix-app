import 'package:flutter/material.dart';
import 'package:techvertix_chat_app/SessionManager.dart';
import 'package:techvertix_chat_app/include/alerts.dart';
import 'package:techvertix_chat_app/include/socket.dart';
import '../login.dart';
import '../screens/contact.dart';
import '../screens/recent_chats.dart';
import 'groups.dart';
import 'Search.dart';
class dashboard extends StatefulWidget {
  final List<String> list = List.generate(10, (index) => "Text $index");
  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
contacts cc = new contacts();
  alerts al = new alerts();
  socketIoClass sio = new socketIoClass();
  String Current_id ;
  @override
  void initState() {
    SessionManager pref = new SessionManager();
    Future<String> authToken = pref.getAuthToken();
    authToken.then((data) {
      Current_id = data;
      if(data.toString() == "" || data.toString() == null || data.toString() == "null"){
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }else{
        // al.SuccessMessage("Wellcome Dashboard");
      }
    },onError: (e) {
      al.ErrorMessage(e);
    });
    super.initState();
    sio.connectToServer();
  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Color(0xFF012055),
        body: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Color(0xFF012075),
              brightness: Brightness.dark,
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.chat_bubble_sharp,color: Color(0xFFFC6601),),child: Text("Chats",style: TextStyle(color: Color(0xFFFC6601)),),),
                  Tab(icon: Icon(Icons.contact_page_sharp,color: Color(0xFFFC6601)),child: Text("Contacts",style: TextStyle(color: Color(0xFFFC6601)),),),
                  Tab(icon: Icon(Icons.supervised_user_circle_rounded,color: Color(0xFFFC6601)),child: Text("Groups",style: TextStyle(color: Color(0xFFFC6601)),),),
                ],
              ),
              // elevation: 0.0,
              // actions: <Widget>[
              //   IconButton(
              //     icon: Icon(Icons.search),
              //     iconSize: 30.0,
              //     color: Color(0xFFFC6601),
              //     onPressed: () {
              //       showSearch(context: context, delegate: Search(widget.list));
              //       // pref.logout();
              //       // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              //
              //     },
              //   ),
              // ],
              // title: Text('Techvertix Chat App'),
            ),

            body: TabBarView(

              children: [
                Container(
                  child:RecentChats(),
                ),
                Container(
                  child:contacts(),
                ),
                Container(
                  child:groups(),
                ),
              ],
            ),
          ),
        )

    );
  }
}

