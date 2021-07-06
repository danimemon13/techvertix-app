import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bubble/bubble.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:chatbar/chatbar.dart';
import 'package:http/http.dart' as http;
import 'package:delayed_display/delayed_display.dart';
import '../SessionManager.dart';
import '../include/alerts.dart';
import '../ApiClientWeb/ApiClass.dart';
import '../screens/image_screen.dart';

class ChatScreen extends StatefulWidget {
  String id;
  String user;
  String senderid;
  String userimg;
  String dv_id;
  ChatScreen({this.id,this.user,this.senderid,this.userimg,this.dv_id});

  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool show = true;
  Response response;
  String progress;
  Dio dio = new Dio();
  File uploadimage,tempImage,uploadvideo,tempVideo;
  SessionManager pref = new SessionManager();
  List<dynamic> list = [];
  getData() async{
    var res = await http.post(
        "http://estudentarea.com/chat_app/getmsgs.php",
        body: {'reciever': widget.id,"sender":widget.senderid}
    );
    //  setState(() {
    //   show = false;
    //  });
    // print(res.body);
    list = jsonDecode(res.body);
    // print(list);
    // return jsonDecode(res.body);
  }
  // VideoPlayerController _videoPlayerController;
  // VideoPlayerController _cameraVideoPlayerController;

  chooseImage(option) async {
    if(option == 0){
      print(uploadimage);
      uploadimage = null;
      uploadimage = await FilePicker.getFile(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'png'],
      );
      setState(() {});
    }else{
      print(uploadimage);
      uploadimage = null;
      var choosedimage = await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        uploadimage = choosedimage;
      });
    }
  }
  chosseVideo(option) async {
    if(option == 0){
      print(uploadvideo);
      uploadvideo = null;
      uploadvideo = await FilePicker.getFile(
          type: FileType.custom,
          allowedExtensions: ['mp4'],
      );
      setState(() {});
    }else{
      var choosevideo = await ImagePicker.pickVideo(source: ImageSource.camera);
      setState(() {
        uploadvideo = choosevideo;
      });
    }
  }

  String c_d_i;
  Socket socket;
  void initState(){
    getData();
    Future<String> authToken = pref.getDeviceId();

    authToken.then((data) {
      
      c_d_i = data;
      //al.SuccessMessage("Getting Meesages Of User id  Of" + data.toString());
    },onError: (e) {
      al.ErrorMessage(e);
    });
    super.initState();
    connectToServer();
    Timer(Duration(seconds: 1), () {
          setState(() {
            show = false;
          });
    });
  }
   void connectToServer() {
    try {
     
      // Configure socket transports must be sepecified
      // socket = io('http://10.0.3.45:3000', <String, dynamic>{
        
      socket = io('http://142.11.200.186:3002', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
     
      // Connect to websocket
      socket.connect();
     
      // Handle socket events
      socket.on('connect', (_) => print('connect: ${socket.id}'));
      // socket.on('location', handleLocationListen);
      // socket.on('typing', handleTyping);
      socket.on('chat message', handleMessage);
      // socket.on('disconnect', (_) => print('disconnect'));
      // socket.on('fromServer', (_) => print(_));

    } catch (e) {
      print(e.toString());
    }

   
  }
  sendMessage(String message, String type) {
    // print(message);
      socket.emit("message",
        {
          "id": "", 
          "sender_id": widget.senderid, 
          "reciever_id": widget.id,
          "message": message,
          "message_type": type,
          "status": "32",
          "read_status": "1",
          "send_date": "2021-05-21 04:05:41",
          "read_date": "2021-05-21 04:05:41",
        },
      );
  }
  void handleMessage(data) {
    print(data);
     final convertdata = jsonDecode(data);
     if(convertdata['sender_id'].toString() == widget.senderid.toString() || convertdata['reciever_id'].toString() == widget.senderid.toString()){
         if(convertdata['message_type'].toString() == 'img'){
            if (mounted) {
              setState(() {
                list.insert(0, convertdata);
              });
            }
         }else{
          if (mounted) {
              setState(() {
                list.insert(0, convertdata);
                  // isFirstLoad = false;
              });
         
              // Timer(Duration(seconds: 1), () {
              //   setState(() {
              //     isFirstLoad = true;
              //   });
              // });
            }
         }
        
     }
            // print("this is test");
            // print(list[1]["message"]);
            // print("this is test");
    
  }
  
  TextEditingController msg_controller = new TextEditingController();
  String getmessage;
  alerts al = new alerts();
  CustomApi ca = new CustomApi();
  ScrollController _scrollController = new ScrollController();
  final navigatorKey = GlobalKey<NavigatorState>();
  final Duration initialDelay = Duration(seconds: 0);
  
  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Color(0xFF012075),
      child: Row(
        children: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(
                Icons.image,
                color: Color(0xFFFC6601)
            ),
            enabled: true,
            onSelected: (str) {
              if(str == '0'){
                chooseImage(0);
              }else if(str == '1'){
                chooseImage(1);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              const PopupMenuItem<String>(
                value: '0',
                child: Text('Form Device'),
              ),
              const PopupMenuItem<String>(
                value: '1',
                child: Text('Form Camera'),
              ),
            ],
          ),

          PopupMenuButton<String>(
            icon: Icon(
                Icons.switch_video_rounded,
                color: Color(0xFFFC6601)
            ),
            enabled: true,
            onSelected: (str) {
              if(str == '0'){
                chosseVideo(0);
              }else if(str == '1'){
                chosseVideo(1);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              const PopupMenuItem<String>(
                value: '0',
                child: Text('Form Device'),
              ),
              const PopupMenuItem<String>(
                value: '1',
                child: Text('Form Camera'),
              ),
            ],
          ),
          Expanded(
            child: TextField(
              controller: msg_controller,
              style: TextStyle(color: Colors.white),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                // print("value is "+value);
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
            icon: Icon(Icons.send,color: Color(0xFFFC6601)),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              // final res = await ca.sendMsg(widget.senderid,widget.id,uploadimage);
              if(getmessage==''||getmessage==null||getmessage=="null"){
                al.ErrorMessage("empty");
              }else{
                sendMessage(getmessage,'text');
                final res = await ca.sendTextMsg(widget.senderid,widget.id,'$getmessage');
                // al.SuccessMessage("image is"+uploadimage.toString());
                if(res == "Inserted"){
                  ca.sendNotification(widget.dv_id,"single");
                }else {
                  al.ErrorMessage("Some Thing Went Wrong... Try Again !!");
                }
                if(mounted){
                  setState(() {
                  msg_controller.clear();
                  getmessage = null;
                });
                }
              }
              // }else{
              //   final res = await ca.sendMsg(widget.senderid,widget.id,uploadimage);
              // }

            },
          ),
        ],
      ),
    );
  }
  // bool isFirstLoad = false;
  _buildMessage(String message,bool isMe, String type) {
    
    final Container abc = Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
      width: MediaQuery.of(context).size.width * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Bubble(
            margin: BubbleEdges.only(top: 10,left:isMe?60:10,right:isMe?10:60),
            alignment: isMe? Alignment.topRight: Alignment.topLeft,
            nip: isMe? BubbleNip.rightBottom : BubbleNip.leftBottom,
            color: isMe? Color(0xFFFC6601): Color(0xFF012075),
            child: type == 'text'?Text(
              message,
              style:
              TextStyle(
                  color: isMe?Color(0xFF012075):Colors.white),)
                :GestureDetector(
              child:FadeInImage(
                height: 300,
                width: 300,
                fit: BoxFit.fitWidth,
                image: NetworkImage("http://estudentarea.com/chat_app/"+message,
                
                ),
                placeholder: AssetImage(
                    "assets/msg_loader.gif",
                    
                    ),
                imageErrorBuilder:
                    (context, error, stackTrace) {
                      return FadeInImage(
                        image: FileImage(tempImage,),
                          placeholder: AssetImage("assets/msg_loader.gif",),
                          imageErrorBuilder:
                            (context, error, stackTrace) {
                               return Image.asset(
                                'assets/error.png',
                                fit: BoxFit.fitWidth);
                            }
                      );
                      
                      // return Image.file(tempImage);
                  // return Image.asset(
                  //     'assets/error.png',
                  //     fit: BoxFit.fitWidth);
                },
                // fit: BoxFit.fitWidth,
              ),
              // child: Image.network("http://estudentarea.com/chat_app/"+message),
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
        // onprofileimagetap: () => show(),
        profilePic: Image.network(
          "http://estudentarea.com/es-v1/chat_app_area/"+widget.userimg,
          height: 50,
          width: 50,
          fit: BoxFit.contain,
        ),
        username: widget.user,
        status: Text('Online',style: TextStyle(color: Colors.white),),

        color: Color(0xFF012075),
        // gradient: Gradient(colors: red),
        backbuttoncolor: Colors.white,
        backbutton: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            list.clear();
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        actions: <Widget>[
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.phone),
          //   color: Colors.white,
          // ),
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
        // onTap: () => FocusScope.of(context).unfocus(),
        child:uploadimage != null || uploadvideo !=null ?
        //if uploadimage is null then show empty container
        Container(
          color: Colors.white,
          child: Center(
              child:Column(
                children: <Widget>[
                  uploadimage == null?
                  Image.file(uploadimage ,width: double.infinity,height: 400,):
                  Image.file(uploadimage ,width: double.infinity,height: 400,)
                  ,
                  RaisedButton(
                    onPressed: () async {
                      print(list.length);
                       setState(() {
                      tempImage = uploadimage;
                    });
                      sendMessage(tempImage.toString(), 'img');
                    // al.SuccessMessage("pressed");
                    setState(() {
                      uploadimage = null;
                    });
                    final res = await ca.sendImage(widget.senderid,widget.id,tempImage);
                  //  isFirstLoad = false;
                  }, child: Text("Send")),
                ],
              )
          ),
        ): Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.white,
                child: ClipRect(
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
                    final msg = list[index]["message"];
                    String type = list[index]["message_type"];
                    final bool isMe = list[index]["sender_id"] == widget.senderid;
                    print(list[index]);
                        return _buildMessage(msg,isMe,type);
                        },
                      ),
                    ),
                  ) ,
                ),
              ),
            _buildMessageComposer(),
          ],
        ),
      ),
      // body: GestureDetector(
      //   onTap: () => FocusScope.of(context).unfocus(),
      //   child:uploadimage != null?
      //   //if uploadimage is null then show empty container
      //   Container(
      //     color: Colors.white,
      //     child: Center(
      //         child:Column(
      //           children: <Widget>[
      //             Image.file(uploadimage,width: double.infinity,height: 400,),
      //             RaisedButton(onPressed: () async {
      //               al.SuccessMessage("pressed");
      //               final res = await ca.sendMsg(widget.senderid,widget.id,uploadimage);
      //               print("go");
      //               setState(() {

      //                 uploadimage = null;
      //               });
      //             }, child: Text("Send")),
      //           ],
      //         )
      //     ),
      //   ): Column(
      //     children: <Widget>[
      //       Expanded(
      //         child: Container(
      //           color: Colors.white,
      //           child: ClipRRect(
      //             child: _buildList(),
      //             // child:  FutureBuilder(
      //             //     builder: (context, snapshot){
      //             //       if(!snapshot.hasData){
      //             //         return Center(
      //             //           child: Text(
      //             //             "Loading...",
      //             //             style: TextStyle(color: Colors.black,backgroundColor: Colors.white),
      //             //           ),
      //             //         );
      //             //       }else if(snapshot.hasError){
      //             //         return Center(
      //             //           child: Text("Error"),
      //             //         );
      //             //       }else if(snapshot.hasData){
      //             //         return ListView.builder(
      //             //           reverse: true,
      //             //           padding: EdgeInsets.only(top: 15.0),
      //             //           itemCount: snapshot.data.length,
      //             //           itemBuilder: (BuildContext context, int index) {
      //             //             String msg = snapshot.data[index]["message"];
      //             //             String type = snapshot.data[index]["message_type"];
      //             //             final bool isMe = snapshot.data[index]["sender_id"] == widget.senderid;
      //             //             return _buildMessage(msg,isMe,type);
      //             //           },
      //             //         );
      //             //       }
      //             //     },
      //             //     future: getData()
      //             // ),
      //           ),
      //         ),
      //       ),
      //       _buildMessageComposer(),
      //     ],
      //   ),
      // ),
    );
  }
}
