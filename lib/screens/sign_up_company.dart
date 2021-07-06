import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:techvertix_chat_app/ApiClientWeb/ApiClass.dart';
import 'package:techvertix_chat_app/include/alerts.dart';
import 'package:techvertix_chat_app/login.dart';
import 'package:intl/intl.dart';
class SignupCompany extends StatefulWidget {
  @override
  _SignupCompanyState createState() => _SignupCompanyState();
}
class _SignupCompanyState extends State<SignupCompany> {
  CustomApi ca = new CustomApi();
  alerts al = new alerts();
  final _formKey = GlobalKey<FormState>();
  String companyName,companyUsers,companyEmail,companyCodeGenerate;
  
  // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format();
 void _processData() {
    // Process your data and upload to server
    _formKey.currentState?.reset();
  }
  //
   Future<void> _submit () async {
     if(!_formKey.currentState.validate()){
       return;
     }
     _formKey.currentState.save();
  final getStatus = await ca.registerOrganization(companyName,companyUsers,companyEmail,companyCodeGenerate);
  if(getStatus == "1"){
    al.ErrorMessage("This Company Code Already Registered");
  }else if (getStatus == "2"){
    al.SuccessMessage("Your Comapny Has Been Registered");
    _processData();
  }else{
    al.ErrorMessage("Server Error");
  }


  //  print(companyName);
  //  print(companyUsers);
  //  print(companyEmail);
  //  print(companyCodeGenerate);
    
    // var formatter = new DateFormat('yyyy-MM-dd');
    // String formattedDate = formatter.format(now);
     
  }

  Widget buildName(){
    return TextFormField(
      // onChanged: (value){
      //   setState(() {
      //   companyCodeGenerate = value.toLowerCase()+""+al.getCurrentDateCodeFormat();
      //   print(companyCodeGenerate);
      //   });
      // },
      onSaved: (value) {
        setState(() {
            companyName = value;
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
        hintText: "Enter Comapny Name",
        hintStyle: TextStyle(color: Color(0xFFFC6601)),
      ),
      
    );
  }
  Widget buildEmail(){
    return TextFormField(
      onSaved: (value) {
        setState(() {
            companyEmail = value;
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
        hintText: "Company Email",
        hintStyle: TextStyle(color: Color(0xFFFC6601)),

      ),
    );
  }
  Widget buildNoOfEmployees(){
    return  TextFormField(
      onSaved: (value) {
        setState(() {
          companyUsers = value;
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
        hintText: "How Many Users In Company",
        hintStyle: TextStyle(color: Color(0xFFFC6601)),

      ),
    );
  }
  Widget buildCompanyCode(){
    return TextFormField(
      initialValue: companyCodeGenerate,
      // enabled: false,
      onSaved: (value) {
        setState(() {
            companyCodeGenerate = value;
        });
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Required This Field!';
        }
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        icon: Icon(Icons.qr_code,size:25.0 ,color: Color(0xFFFC6601),),
        border: InputBorder.none,
        hintText: "Company Code",
        hintStyle: TextStyle(color: Color(0xFFFC6601)),
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
                  buildName(),
                  SizedBox(
                      height: 20,
                    ),
                  buildNoOfEmployees(),
                  SizedBox(
                    height: 20,
                  ),
                  buildEmail(),
                  SizedBox(
                    height: 20,
                  ),
                  buildCompanyCode(),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    color:Color(0xFFFC6601),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    padding: EdgeInsets.symmetric(horizontal: 80.0),
                    onPressed:_submit,
                    child: Text("Sign Up Your Company"),
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