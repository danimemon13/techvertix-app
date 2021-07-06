import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bubble/bubble.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:techvertix_chat_app/SessionManager.dart';
import 'package:techvertix_chat_app/include/alerts.dart';
import 'package:chatbar/chatbar.dart';
import 'package:http/http.dart' as http;
import 'package:techvertix_chat_app/ApiClientWeb/ApiClass.dart';
import 'group_users.dart';
import 'image_screen.dart';

class GroupScreen extends StatefulWidget {
  String group_id;
  String group_name;
  String senderid;
  String userimg;

  GroupScreen({this.group_id, this.group_name, this.senderid, this.userimg});

  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  List<dynamic> list = [];
  bool show = true;
  final Duration initialDelay = Duration(seconds: 0);
  getData() async {
    var res = await http.post("http://estudentarea.com/chat_app/get_group_msgs.php",
    body: {'group_id':widget.group_id});
    print(res.body);
    list = jsonDecode(res.body);
    // return jsonDecode(res.body);
  }

  File uploadimage;
  Timer _timer;
  Socket socket;
  Future<void> chooseImage() async {
    var choosedimage = await ImagePicker.pickImage(source: ImageSource.gallery);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      uploadimage = choosedimage;
    });
  }
  void initState() {
    getData();
    // getData
    super.initState();
      Timer(Duration(seconds: 1), () {
      setState(() {
        show = false;
      });
});
  }

  TextEditingController msg_controller = new TextEditingController();
  String getmessage = null;
  alerts al = new alerts();
  CustomApi ca = new CustomApi();
  ScrollController _scrollController = new ScrollController();
  final navigatorKey = GlobalKey<NavigatorState>();

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Color(0xFF012055),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo, color: Color(0xFFFC6601)),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              chooseImage();
            },
          ),
          Expanded(
            child: TextField(
              controller: msg_controller,
              style: TextStyle(color: Colors.white),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                setState(() {
                  getmessage = msg_controller.text;
                });
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
                hintStyle: TextStyle(color: Color(0xFFFC6601)),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Color(0xFFFC6601),
            onPressed: () async {
              if(getmessage==''||getmessage==null||getmessage=="null"){
                al.ErrorMessage("empty");
              }else{
                final res = await ca.sendGroupTextMsg(widget.group_id,widget.senderid,'$getmessage');
                if(res == "Inserted"){
                  Future d = ca.sendNotification(widget.group_id,"group");
                }else {
                  al.ErrorMessage("Some Thing Went Wrong... Try Again !!");
                }
                setState(() {
                  msg_controller.clear();
                  getmessage = null;
                });
              }
            },
          ),
        ],
      ),
    );
  }
bool isFirstLoad = false;
  _buildMessage(String message, bool isMe, String profileName,String type) {
    final Container abc = Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
      width: MediaQuery.of(context).size.width * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Bubble(
            margin: BubbleEdges.only(
                top: 10, left: isMe ? 60 : 10, right: isMe ? 10 : 60)
            ,
            alignment: isMe ? Alignment.topRight : Alignment.topLeft,
            nip: isMe ? BubbleNip.rightBottom : BubbleNip.leftBottom,
            color: isMe ? Color(0xFFFC6601) : Color(0xFF012055),
            child:Text.rich(
                TextSpan(
                    text:  isMe?  "" : profileName+" : \n",
                    style: TextStyle(color: isMe ? Color(0xFF012055) : Colors.cyan[100],fontSize:10),
                    children: <InlineSpan>[
                      type == 'text'?
                      TextSpan(
                        text: message,
                        style: TextStyle(color: isMe ? Color(0xFF012055) : Colors.white,fontSize:15),
                      ):
                      WidgetSpan(
                        child: GestureDetector(
                            child: Image.network("http://estudentarea.com/chat_app/"+message),
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageScreen(url:"http://estudentarea.com/chat_app/"+message),
                                ),
                              );
                            },
                          ),
                      ),
                    ]
                )
            )
          ),
        ],
      ),
    );
    return abc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: ChatBar(
        onprofileimagetap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupUsers(group_id:widget.group_id)));
        },

        profilePic: Image.network(
          "http://estudentarea.com/es-v1/chat_app_area/" + widget.userimg,
          height: 50,
          width: 50,
          fit: BoxFit.contain,
        ),
        username: widget.group_name,
        status: Text(''),
        color: Color(0xFF012055),
        // gradient: Gradient(colors: red),
        backbuttoncolor: Colors.white,
        backbutton: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupUsers(group_id:widget.group_id)));
            },
            icon: Icon(Icons.supervised_user_circle_sharp),
            color: Colors.white,
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.videocam),
          //   color: Colors.white,
          // ),
          // PopupMenuButton<String>(
          //   icon: Icon(
          //     Icons.more_vert,
          //     color: Colors.white,
          //   ),
          //   enabled: true,
          //   onSelected: (str) {},
          //   itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
          //     const PopupMenuItem<String>(
          //       value: 'View Contact',
          //       child: Text('View Contact'),
          //     ),
          //     const PopupMenuItem<String>(
          //       value: 'Media',
          //       child: Text('Media'),
          //     ),
          //     const PopupMenuItem<String>(
          //       value: 'Search',
          //       child: Text('Search'),
          //     ),
          //     const PopupMenuItem<String>(
          //       value: 'Wallpaper',
          //       child: Text('Wallpaper'),
          //     ),
          //   ],
          // )
        ],

      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child:uploadimage != null?
      //if uploadimage is null then show empty container
      Container(
      color: Colors.white,
        child: Center(
            child:Column(
              children: <Widget>[
                Image.file(uploadimage,fit: BoxFit.cover),
                FloatingActionButton(
                    onPressed: () async {
                  final res = await ca.sendGroupImage(widget.group_id,widget.senderid,uploadimage);
                  setState(() {
                    uploadimage = null;
                  });
                }, child: Text("Send")),
              ],
            )
        ),
      ): Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.white,
                child: ClipRRect(
                  child: show ? Center(child: CircularProgressIndicator()) : DelayedDisplay(
                  slidingCurve:Curves.ease,
                  // fadingDuration:Duration(milliseconds: 1000),
                    delay: Duration(seconds: initialDelay.inSeconds),
                    child:list.isEmpty?Center(
                    child: Text("No Chat Available This User"),
                  ):ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.only(top: 15.0),
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        String msg = list[index]["message"];
                        String profileName = list[index]["profilename"];
                        final bool isMe = list[index]["sender_id"] == widget.senderid;
                        String type = list[index]["message_type"];
                        return _buildMessage(msg, isMe, profileName, type);
                      },
                  ),
                  )
                  // child: FutureBuilder(
                  //     builder: (context, snapshot) {
                  //       if (!snapshot.hasData) {
                  //         return Center(
                  //           child: Text(
                  //             "Loading...",
                  //             style: TextStyle(
                  //                 color: Colors.black,
                  //                 backgroundColor: Colors.white),
                  //           ),
                  //         );
                  //       } else if (snapshot.hasError) {
                  //         return Center(
                  //           child: Text("Error"),
                  //         );
                  //       } else if (snapshot.hasData) {
                  //         return ListView.builder(
                  //           reverse: true,
                  //           padding: EdgeInsets.only(top: 15.0),
                  //           itemCount: snapshot.data.length,
                  //           itemBuilder: (BuildContext context, int index) {
                  //             String msg = snapshot.data[index]["message"];
                  //             String profileName = snapshot.data[index]["profilename"];
                  //             final bool isMe = snapshot.data[index]["sender_id"] == widget.senderid;
                  //             String type = snapshot.data[index]["message_type"];
                  //             return _buildMessage(msg, isMe, profileName, type);
                  //           },
                  //         );
                  //       }
                  //     },
                  //     future: getData()
                  //   ),
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}