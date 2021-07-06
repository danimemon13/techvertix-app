import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'sign_up_page.dart';
import 'SessionManager.dart';
import 'screens/dashboard.dart';
import 'ApiClientWeb/ApiClass.dart';
import 'include/alerts.dart';

class LoginPage  extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset:false ,
      body: Column(
        children: <Widget>[
          Container(
            child: Image(
              image: AssetImage("assets/techvertix_logo.png"),
              height: 180,
              width: 180,
            ),
            height: 150,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  LoginFields(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginFields extends StatefulWidget {
  @override
  _LoginFieldsState createState() => _LoginFieldsState();
}
class _LoginFieldsState extends State<LoginFields> {
  SessionManager _sessionManager = new SessionManager();
  alerts al = new alerts();
  CustomApi ca = new CustomApi();
  bool isLoggedIn = false;
  String user_id = '';
  TextEditingController UserController = new TextEditingController();
  TextEditingController PasswordController = new TextEditingController();
  String getusername, getpassword, getdevicetoken;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
          child: Container(
            padding: EdgeInsets.all(50.0),
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
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Column(
                children: [
                  Text(
                    'Login',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24.0,color:  Color(0xFFFC6601)),

                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: UserController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_box,size:25.0 ,color: Color(0xFFFC6601),),
                      border: InputBorder.none,
                      hintText: "Enter User Name",
                      hintStyle: TextStyle(color: Color(0xFFFC6601)),

                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    obscureText:true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: PasswordController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock,size:25.0 ,color: Color(0xFFFC6601)),
                      border: InputBorder.none,
                      hintText: "Enter Password",
                      hintStyle: TextStyle(color: Color(0xFFFC6601)),

                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    color:Color(0xFFFC6601),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    padding: EdgeInsets.symmetric(horizontal: 80.0),
                    onPressed: () {
                      setState(() {
                        getusername = UserController.text;
                        getpassword = PasswordController.text;
                      });
                      perfomlogin();
                    },
                    child: Text("Login"),
                  ),
                  SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account?', style: TextStyle(color:Color(0xFFFC6601), fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '   Sign up', style: TextStyle(color: Colors.white, fontSize: 15),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                                }
                              ),
                            ]
                        ),
                      ),
                    )
                ]
            ),
          )
      )
    );
  }

  Future<void> perfomlogin() async {
    
    if (getusername == '') {
      al.ErrorMessage("Username Required");
    } else if (getpassword == '') {
      al.ErrorMessage("Password Required");
    } else {
  
      Future<String> getdeviceid = _sessionManager.getDeviceId();
      getdeviceid.then(
              (data) async {
          getdevicetoken = data.toString();
          // print("username"+getusername);
          // print("password"+getpassword);
          // print(getdevicetoken);
          final getStatus = await ca.doLogin('$getusername','$getpassword','$getdevicetoken');
         
          final convertdata = jsonDecode(getStatus);
          String id = convertdata['id'];
          String msg = convertdata['status'];
          String c_id = convertdata['company_id'];
         
          if(msg == "success"){
             al.SuccessMessage("Device id is " + data.toString());
            _sessionManager.setAuthToken(id);
            _sessionManager.setCompanyId(c_id);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => dashboard()
                ),
              );
          }else{
            al.ErrorMessage(msg);
          }
          print(getStatus);
        }, onError: (e) {
          al.ErrorMessage(e);
        }
      );

    }
  }
}