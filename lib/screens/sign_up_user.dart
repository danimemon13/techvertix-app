import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:techvertix_chat_app/ApiClientWeb/ApiClass.dart';
import 'package:techvertix_chat_app/include/alerts.dart';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';


import '../login.dart';

class SignupUser extends StatefulWidget {
  @override
  _SignupUserState createState() => _SignupUserState();
}

class _SignupUserState extends State<SignupUser> {
  CustomApi ca = new CustomApi();
  alerts al = new alerts();
  final _formKey = GlobalKey<FormState>();
  String u_name,u_pass,u_p_name,u_p_pic,u_email,u_mobile_no,u_code;
  File file;
  Response response;
   Dio dio = new Dio();
  selectfile() async{
    file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['jpg','png']
    );
    setState(() {
      
    });
  }


   void _processData() {
    // Process your data and upload to server
    _formKey.currentState?.reset();
  }

 uploadFile() async {
     String uploadurl = ca.baseUri+"es-v1/chat_app_area/action.php";
     FormData formdata = FormData.fromMap({
          'name':u_name,'pass':u_pass,'p_name':u_p_name,'u_email':u_email,'mbl_no':u_mobile_no,'company_code':u_code,'action':'signupWithMobile',
          "namee": await MultipartFile.fromFile(
                 file.path, 
                 filename: basename(file.path) 
                 //show only filename from path
           ),
      });
      response = await dio.post(
          uploadurl, 
          data: formdata
          // onSendProgress: (int sent, int total) {
          //     // String percentage = (sent/total*100).toStringAsFixed(2);
          //     setState(() {
          //         //  progress = "$sent" + " Bytes of " "$total Bytes - " +  percentage + " % uploaded";
          //          //update the progress
          //     });
          // },
        );
          
      if(response.statusCode == 200){
            print(response.toString()); 
            if(response.toString() == "1"){
              al.SuccessMessage("Your Account Has Been Registered Successfully !!");
              _processData();
            }else if(response.toString() == "2"){
              al.ErrorMessage("This Company Is Not Registered");
            }else if(response.toString() == "3"){
              al.ErrorMessage("This User Is Already Exits");
            }else{
              al.ErrorMessage("Server Error");
            }
      }else{ 
          print("Error during connection to server.");
      }
  }

   Future<void> _submit () async {
     if(!_formKey.currentState.validate()){
       return;
     }
     _formKey.currentState.save();
      uploadFile();


  // final getStatus = await ca.registerUserWithOrganization(u_name,u_pass,u_p_name,u_p_pic,u_email,u_mobile_no,u_code);
  // print("get Status = "+getStatus);
  // if(getStatus == "1"){
  //   al.SuccessMessage("Your Account Has Been Registered Successfully !!");
  //   _processData();
  // }else if(getStatus == "2"){
  //   al.ErrorMessage("This Company Is Not Registered");
  // }else if(getStatus == "3"){
  //   al.ErrorMessage("This User Is Already Exits");
  // }else{
  //   al.ErrorMessage("Server Error");
  // }


  //  print(companyName);
  //  print(companyUsers);
  //  print(companyEmail);
  //  print(companyCodeGenerate);
    
    // var formatter = new DateFormat('yyyy-MM-dd');
    // String formattedDate = formatter.format(now);
     
  }

  Widget buildName(){
    return TextFormField(
      onSaved: (value) {
        setState(() {
            u_name = value;
        });
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Required This Field!';
        }
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        icon: Icon(Icons.account_box,size:25.0 ,color: Color(0xFFFC6601),),
        border: InputBorder.none,
        hintText: "Enter User Name Without Spaces",
        hintStyle: TextStyle(color: Color(0xFFFC6601)),
      ),
      
    );
  }
  Widget buildPassword(){
    return TextFormField(
      onSaved: (value) {
        setState(() {
            u_pass = value;
        });
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Required This Field!';
        }
      },
      style: TextStyle(color: Colors.white),
      obscureText:true,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        icon: Icon(Icons.lock,size:25.0 ,color: Color(0xFFFC6601)),
        border: InputBorder.none,
        hintText: "Enter Password",
        hintStyle: TextStyle(color: Color(0xFFFC6601)),

      ),
    );
  }
  Widget buildProfileName(){
    return  TextFormField(
      onSaved: (value) {
        setState(() {
          u_p_name = value;
        });
      },
      validator: (value) {
        // if (value.isEmpty || !value.contains('@')) {
        if (value.isEmpty) {
           return 'Required This Field!';
        }
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        icon: Icon(Icons.supervised_user_circle_sharp,size:25.0 ,color: Color(0xFFFC6601)),
        border: InputBorder.none,
        hintText: "Enter Profile Name",
        hintStyle: TextStyle(color: Color(0xFFFC6601)),

      ),
    );
  }
  Widget buildEmail(){
     return TextFormField(
      onSaved: (value) {
        setState(() {
            u_email = value;
        });
      },
      validator: (value) {
        if (value.isEmpty || !value.contains('@')) {
          return 'Invalid email!';
        }
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        icon: Icon(Icons.mail,size:25.0 ,color: Color(0xFFFC6601)),
        border: InputBorder.none,
        hintText: "Enter Your Email",
        hintStyle: TextStyle(color: Color(0xFFFC6601)),

      ),
    );
  }
  Widget buildPhoneNo(){
     return TextFormField(
      onSaved: (value) {
        setState(() {
            u_mobile_no = value;
        });
      },
      validator: (value) {
        if (value.isEmpty ) {
           return 'Required This Field!';
        }
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        icon: Icon(Icons.phone,size:25.0 ,color: Color(0xFFFC6601)),
        border: InputBorder.none,
        hintText: "Enter Phone no",
        hintStyle: TextStyle(color: Color(0xFFFC6601)),

      ),
    );
  }
  Widget buildComapnyCode(){
     return TextFormField(
      onSaved: (value) {
        setState(() {
            u_code = value;
        });
      },
      validator: (value) {
        if (value.isEmpty ) {
           return 'Required This Field!';
        }
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        icon: Icon(Icons.qr_code,size:25.0 ,color: Color(0xFFFC6601)),
        border: InputBorder.none,
        hintText: "Enter Company Code",
        hintStyle: TextStyle(color: Color(0xFFFC6601)),

      ),
    );
  }
  Widget buildProfileImage(){
     return GestureDetector(
       onTap: (){
         selectfile();
       },
        child: CircleAvatar(
            backgroundImage: file == null ? AssetImage("assets/avatar.png"): FileImage(file),
            radius: 90,
            // child: Text('Eevee'),
            foregroundColor: Colors.red,
        ),
     );
  }
  
   @override
   Widget build(BuildContext context) {
     return SingleChildScrollView(
       child: Container(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    const Color(0xFFFC6601),
                    const Color(0xFF012055),
                  ],
                  begin: const FractionalOffset(1.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp
              ),
            ),
        child:Form(
    key: _formKey,
    child: Column(
          children:<Widget> [
                   SizedBox(
                      height: 20,
                    ),
                  buildProfileImage(), 
                   SizedBox(
                      height: 20,
                    ),
                  buildName(),
                  SizedBox(
                      height: 20,
                    ),
                  buildPassword(),
                  SizedBox(
                    height: 20,
                  ),
                  buildProfileName(),
                  SizedBox(
                    height: 20,
                  ),
                  buildEmail(),
                  SizedBox(
                    height: 20,
                  ),
                  buildPhoneNo(),
                  SizedBox(
                    height: 20,
                  ),
                  buildComapnyCode(),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    color:Color(0xFFFC6601),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    padding: EdgeInsets.symmetric(horizontal: 80.0),
                    onPressed:_submit,
                    child: Text("Sign Up Account"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have account?', style: TextStyle(color:Color(0xFFFC6601), fontSize: 15),
                          children: <TextSpan>[
                            TextSpan(
                                text: '   Login', style: TextStyle(color: Colors.white, fontSize: 15),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                              }
                            ),
                          ]
                      ),
                    ),
                  ),
                  SizedBox(
                  height: 20,
                  ),
                ]
          ),
       ),
       ),
      );
  }

}