import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../SessionManager.dart';
import 'chat_screen.dart';
import '../include/alerts.dart';

class contacts extends StatefulWidget {
  @override
  _contactsState createState() => _contactsState();
}

class _contactsState extends State<contacts> {
  String CurrentUserId;
  String CurrentUserCompanyId;
  Timer _timer;
  @override

  void initState() {
    SessionManager pref = new SessionManager();
    Future<String> authToken = pref.getAuthToken(); 
    Future<String> authComapny = pref.getCurrentUserCompanyID();

    authToken.then((data) {
      CurrentUserId = data;
      //al.SuccessMessage("Getting Meesages Of User id  Of" + data.toString());
    },onError: (e) {
      al.ErrorMessage(e);
    });
     authComapny.then((data) {
      CurrentUserCompanyId = data;
      //al.SuccessMessage("Getting Meesages Of User id  Of" + data.toString());
    },onError: (e) {
      al.ErrorMessage(e);
    });
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if(mounted){
        setState(() {
          future: getData();
        });
      }
    });

  }

  Future<List<dynamic>> getData() async{
    var res = await http.post(
        "http://estudentarea.com/chat_app/contacts.php",
      body: {'sess_id': CurrentUserId,'fk_organization_id':CurrentUserCompanyId}
    );
    print(res.body);
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
              child: Text("No User Have In Your Comapny"),
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
                          builder: (_) => ChatScreen(
                            id:snapshot.data[index]["user_id"],
                            user:snapshot.data[index]["user_name"],
                            senderid:CurrentUserId,
                            userimg:snapshot.data[index]["user_pic"],
                            dv_id: snapshot.data[index]["user_device_id"],
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
                                  backgroundImage: NetworkImage("http://estudentarea.com/es-v1/chat_app_area/"+snapshot.data[index]["user_pic"]),
                                  // backgroundImage: NetworkImage("http://estudentarea.com/chatapp/php/images/"+snapshot.data[index]["profile_picture"]),
                                ),
                                SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data[index]["user_name"],
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
                                        snapshot.data[index]["user_email"],
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 15.0,
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
