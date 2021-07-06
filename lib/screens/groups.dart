import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../include/alerts.dart';
import '../SessionManager.dart';
import 'group_screen.dart';

class groups extends StatefulWidget {
  @override
  _groupssState createState() => _groupssState();
}
class _groupssState extends State<groups> {
  String CurrentUserId;
  @override
  void initState() {
    SessionManager pref = new SessionManager();
    Future<String> authToken = pref.getAuthToken();

    authToken.then((data) {
      CurrentUserId = data;
      //al.SuccessMessage("Getting Meesages Of User id  Of" + data.toString());
    },onError: (e) {
      al.ErrorMessage(e);
    });
    super.initState();
  }
  Future<List<dynamic>> getData() async{
    var res = await http.post(
        "https://estudentarea.com/chat_app/groups.php",
        body: {'member_id':CurrentUserId}
    );
    return jsonDecode(res.body);
  }
  alerts al = new alerts();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: Text("Loading..."),
            );
          }else if(snapshot.hasError){
            return Center(
              child: Text("Error"),
            );
          }else if(snapshot.hasData){
            return Center(
              child: Container(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GroupScreen(
                            //user: chat.sender,
                            group_id:snapshot.data[index]["fk_group_id"],
                            group_name:snapshot.data[index]["group_name"],
                            senderid:CurrentUserId,
                            userimg:snapshot.data[index]["group_icon"],
                          ),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
                        padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          // color: chat.unread ? Color(0xFFFFEFEE) : Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 35.0,
                                  backgroundImage: NetworkImage("https://estudentarea.com/es-v1/chat_app_area/"+snapshot.data[index]["group_icon"]),
                                  // backgroundImage: NetworkImage("https://estudentarea.com/chatapp/php/images/"+snapshot.data[index]["profile_picture"]),
                                ),
                                SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data[index]["group_name"],
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5.0),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      child: Text(
                                        "Group Created at"+snapshot.data[index]["created_at"],
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  // chat.time,
                                  '5:30 PM',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                // chat.unread
                                //     ? Container(
                                //         width: 40.0,
                                //         height: 20.0,
                                //         decoration: BoxDecoration(
                                //           color: Theme.of(context).primaryColor,
                                //           borderRadius: BorderRadius.circular(30.0),
                                //         ),
                                //         alignment: Alignment.center,
                                //         child: Text(
                                //           'NEW',
                                //           style: TextStyle(
                                //             color: Colors.white,
                                //             fontSize: 12.0,
                                //             fontWeight: FontWeight.bold,
                                //           ),
                                //         ),
                                //       )
                                //     : Text(''),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        }

    );
  }
}
