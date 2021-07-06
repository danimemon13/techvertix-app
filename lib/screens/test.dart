import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:chatbar/chatbar.dart';
import '../SessionManager.dart';
import '../include/alerts.dart';
import '../ApiClientWeb/ApiClass.dart';
import '../screens/image_screen.dart';

// import 'package:video_player/video_player.dart';

class abc extends StatefulWidget {


  _abcState createState() => _abcState();
}

 Future<List<Data>> getData() async{
     var res = await http.post(
         "http://estudentarea.com/chat_app/getmsgs.php",
         body: {'reciever': '1',"sender":'3'}
     );
     if (res.statusCode == 200) {
       List jsonResponse = json.decode(res.body);
       return jsonResponse.map((data) => new Data.fromJson(data)).toList();
     }
      print(res.body);
     // return jsonDecode(res.body);
   }
 
class Data {
   final String id;
  final String sender_id;
  final String reciever_id;
  final String message;
  final String message_type;
  final String status;
  final String read_status;
  final String send_date;
  final String read_date;


  Data({ this.id,
    this.sender_id,
    this.reciever_id,
    this.message,
    this.message_type,
    this.status,
    this.read_status,
    this.send_date,
    this.read_date,});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      sender_id: json['sender_id'],
      reciever_id: json['reciever_id'],
      message: json['message'],
      message_type: json['message_type'],
      status: json['status'],
      read_status: json['read_status'],
      send_date: json['send_date'],
      read_date: json['read_date'],
    );
  }
}

class _abcState extends State<abc> {

 




  File uploadimage;
  SessionManager pref = new SessionManager();
  Future<void> chooseImage(option) async {
    if(option == 0){
      var choosedimage = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        uploadimage = choosedimage;
      });
    }else{
      var choosedimage = await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        uploadimage = choosedimage;
      });
    }
  }
  Future<void> chosseVideo(option) async {
    if(option == 0){
      var choosedimage = await ImagePicker.pickVideo(source: ImageSource.gallery);
      setState(() {
        uploadimage = choosedimage;
      });
    }else{
      var choosedimage = await ImagePicker.pickVideo(source: ImageSource.camera);
      setState(() {
        uploadimage = choosedimage;
      });
    }
  }
  String c_d_i;

  Future <List<Data>> futureData;

  @override
  void initState(){
    futureData = getData();
    futureData.then((value) => print(value));
    Future<String> authToken = pref.getDeviceId();
    authToken.then((data) {
      c_d_i = data;
      //al.SuccessMessage("Getting Meesages Of User id  Of" + data.toString());
    },onError: (e) {
      al.ErrorMessage(e);
    });
    super.initState();
  }
  TextEditingController msg_controller = new TextEditingController();
  String getmessage;
  alerts al = new alerts();
  CustomApi ca = new CustomApi();
  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Color(0xFF012055),
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
              getData();
              
              // //final res = await ca.sendMsg(widget.senderid,widget.id,uploadimage);
              // if(getmessage==''||getmessage==null||getmessage=="null"){
              //   al.ErrorMessage("empty");
              // }else{
              //   final res = await ca.sendTextMsg(widget.senderid,widget.id,'$getmessage');
              //   // al.SuccessMessage("image is"+uploadimage.toString());
              //   if(res == "Inserted"){
              //     ca.sendNotification(widget.dv_id,"single");
              //   }else {
              //     al.ErrorMessage("Some Thing Went Wrong... Try Again !!");
              //   }
              //   setState(() {
              //     msg_controller.clear();
              //     getmessage = null;
              //   });
              // }
              // // }else{
              // //   final res = await ca.sendMsg(widget.senderid,widget.id,uploadimage);
              // // }

            },
          ),
        ],
      ),
    );
  }
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
            color: isMe? Color(0xFFFC6601): Color(0xFF012055),
            child: type == 'text'?Text(
              message,
              style:
              TextStyle(
                  color: isMe?Color(0xFF012055):Colors.white),)
                :GestureDetector(
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
        ],
      ),
    );
    return abc;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        
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
                  Image.file(uploadimage,width: double.infinity,height: 400,),
                  RaisedButton(onPressed: () async {
                    al.SuccessMessage("pressed");
                    print("go");
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
                  // child:  ListView.builder(
                  //     reverse: true,
                  //     padding: EdgeInsets.only(top: 15.0),
                  //     itemCount: snapshot.data.length,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       String msg = snapshot.data[index]["message"];
                  //       String type = snapshot.data[index]["message_type"];
                  //       final bool isMe = snapshot.data[index]["sender_id"] == widget.senderid;
                  //       return _buildMessage(msg,isMe,type);
                  //     },
                  //   ),
                      
                  child:  FutureBuilder(
                      builder: (context, snapshot){
                        if(!snapshot.hasData){
                          return Center(
                            child: Text(
                              "Loading...",
                              style: TextStyle(color: Colors.black,backgroundColor: Colors.white),
                            ),
                          );
                        }else if(snapshot.hasError){
                          return Center(
                            child: Text("Error"),
                          );
                        }else if(snapshot.hasData){
                          return ListView.builder(
                            reverse: true,
                            padding: EdgeInsets.only(top: 15.0),
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text('a');
                              // String msg = snapshot.data[index]["message"];
                              // String type = snapshot.data[index]["message_type"];
                              // final bool isMe = snapshot.data[index]["sender_id"] == widget.senderid;
                              // return _buildMessage(msg,isMe,type);
                            },
                          );
                        }
                      },
                      future: futureData,
                  ),
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
