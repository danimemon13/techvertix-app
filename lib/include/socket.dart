
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:techvertix_chat_app/screens/chat_screen.dart';
import '../screens/test.dart';

class socketIoClass {
  ChatScreen cc = new ChatScreen();
  Socket socket;
 void connectToServer() {
    try {
     
      // Configure socket transports must be sepecified
      socket = io('http://techvertixchatapp.estudentarea.com:2000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
     
      // Connect to websocket
      socket.connect();
     
      // Handle socket events
      socket.on('connect', (_) => print('connect: ${socket.id}'));
      // socket.on('location', handleLocationListen);
      // socket.on('typing', handleTyping);
      // socket.on('chat message', handleMessage);
      // socket.on('disconnect', (_) => print('disconnect'));
      // socket.on('fromServer', (_) => print(_));

    } catch (e) {
      print(e.toString());
    }

   
  }
   
  // // Send Location to Server
  // sendLocation(Map<String, dynamic> data) {
  //   socket.emit("location", data);
  // }
   
  // // Listen to Location updates of connected usersfrom server
  // handleLocationListen(Map<String, dynamic> data) async {
  //   print(data);
  // }

  // // Send update of user's typing status 
  // sendTyping(bool typing) {
  //   socket.emit("typing",
  //     {
  //       "id": socket.id,
  //        "typing": typing,
  //     });
  // }
   
  // // Listen to update of typing status from connected users
  // void handleTyping(Map<String, dynamic> data) {
  //   print(data);
  // }
String currnet_id = "3";
  // Send a Message to the server
  sendMessage(String message) {
    connectToServer();
      socket.emit("message",
        {
          "id": "3", 
          "sender_id": "3", 
          "reciever_id": currnet_id,
          "message": message,
          "message_type": "text",
          "status": "1",
          "read_status": "1",
          "send_date": "2021-05-21 04:05:41",
          "read_date": "2021-05-21 04:05:41",
        },
      );
  }
  
  // Listen to all message events from connected users
   
  // void addDataToList(Photo data){
  //       PhotosList.add(data);
  //   }
   
}
  
  

   