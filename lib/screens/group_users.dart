import 'dart:convert';
import 'package:flutter/material.dart';
import '../screens/chat_screen.dart';
// import 'package:flutter_chat_ui/screens/chat_screen.dart';
import 'package:http/http.dart' as http;
class GroupUsers extends StatelessWidget {
  String group_id;
  GroupUsers({this.group_id});

  Future<List<dynamic>> getData() async{
    var response = await http.post(
        "https://estudentarea.com/chat_app/get_group_users.php"
        , body: {'group_id': group_id}
        );
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text(
         "Group Users"
       ),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(
                child: Text(
                    "Loading....."
                ),
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
                        // onTap: () => Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => ChatScreen(
                        //       //user: chat.sender,
                        //       id:snapshot.data[index]["user_id"],
                        //       user:snapshot.data[index]["user_name"],
                        //       senderid:CurrentUserId,
                        //       userimg:snapshot.data[index]["user_pic"],
                        //     ),
                        //   ),
                        // ),
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
                                    backgroundImage: NetworkImage("https://estudentarea.com/es-v1/chat_app_area/"+snapshot.data[index]["profile_picture"]),
                                  ),
                                  SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data[index]["profile_name"],
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.45,
                                      ),
                                    ],
                                  ),
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

      ),
    );
  }
}
