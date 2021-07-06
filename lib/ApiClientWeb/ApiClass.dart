import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
class CustomApi {
  String baseUri = "https://estudentarea.com/";
  Future sendNotification(String token1, String type) async{
    if(token1 != null ){
      String u = baseUri+"chat_app/testing.php";
      var response = await http.post(u,
          body:{"token":token1,"type":type});
      // print(response.body);
      return json.decode(response.body);
    }else{
      print("Token Is Null");
    }
  }
  doLogin(String user,String pass,String device_id) async {
    var u = baseUri+"chat_app/index.php";
    var response = await http.post(
        u, body: {'user': user, 'password': pass, 'device_id':device_id});
     return response.body;
  }
  sendGroupTextMsg(String group_id,String sender_id,String msg) async {
    var u = baseUri+"chat_app/add_group_msg.php";
    var response = await http.post(
        u, body: {'group_id': group_id,'sender_id': sender_id,'msg': msg});
    return response.body;
  }
  sendTextMsg(String sender_id,String reciver_id,String msg) async {
    var u = baseUri+"chat_app/add_msg.php";
    var response = await http.post(
        u, body: {'sender': sender_id,'reciever': reciver_id,'msg': msg});

    return response.body;
  }
  Future<void> sendGroupImage(String group_id,String sender_id,File uploadimage) async {
    String data;
    String uploadurl = baseUri+"chat_app/add_group_msg.php";
    try{
      List<int> imageBytes = uploadimage.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      var response = await http.post(
          uploadurl,
          body: {
            'group_id': group_id,
            'sender_id': sender_id,
            'image': baseimage,
          }
      );
      if(response.statusCode == 200){
        var jsondata = json.decode(response.body);
        if(jsondata["error"]){ //check error sent from server
          data = jsondata["msg"];
          //if error return from server, show message from server
        }else{
          data = "Upload successful";
        }
      }else{
        data = "Error during connection to server";
        //there is error during connecting to server,
        //status code might be 404 = url not found
      }
    }catch(e){
      data = "Error during converting to Base64";
    }
    return data;
  }
  Future<void> sendImage(String sender_id,String reciver_id,File uploadimage) async {

    String data;
    String uploadurl = baseUri+"chat_app/add_msg.php";
    try{
      List<int> imageBytes = uploadimage.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      var response = await http.post(
          uploadurl,
          body: {
            'sender': sender_id,
            'reciever': reciver_id,
            'image': baseimage,
          }
      );
      if(response.statusCode == 200){
        var jsondata = json.decode(response.body); //decode json data
        if(jsondata["error"]){ //check error sent from server
          data = jsondata["msg"];
          //if error return from server, show message from server
        }else{
          data = "Upload successful";
        }
      }else{
        data = "Error during connection to server";
        //there is error during connecting to server,
        //status code might be 404 = url not found
      }
    }catch(e){
      data = "Error during converting to Base64";
      //there is error during converting file image to base64 encoding.
    }
    return data;
  }
  registerOrganization(String name,String users, String email, String code) async {
     var u = baseUri+"chat_app/add_organization.php";
    var response = await http.post(
        u, body: {'name':name,'users':users,'email':email,'code':code});
        print(response.body);
    return response.body;
  }
  registerUserWithOrganization(String name,String pass,String p_name,String p_pic,String u_email,String mbl_no,String company_code) async {
     var u = baseUri+"es-v1/chat_app_area/action.php";
    var response = await http.post(
      // 'p_pic':p_pic,
        u, body: {'name':name,'pass':pass,'p_name':p_name,'u_email':u_email,'mbl_no':mbl_no,'company_code':company_code,'action':'signupWithMobile'});
        print(response.body);
    return response.body;
  }
}
