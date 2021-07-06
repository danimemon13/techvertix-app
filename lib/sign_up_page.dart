import 'package:flutter/material.dart';
import 'package:techvertix_chat_app/screens/sign_up_company.dart';
import 'package:techvertix_chat_app/screens/sign_up_user.dart';
class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Sign Up"),
              // title: Text("Sign Up",style: TextStyle(color: Color(0xFF012055)),),
              automaticallyImplyLeading: true,
              backgroundColor: Color(0xFF012055),
              // backgroundColor: Colors.white
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.assignment_ind_outlined,color: Color(0xFFFC6601),),text: 'Signup as User'),
                  Tab(icon: Icon(Icons.quick_contacts_mail_rounded,color: Color(0xFFFC6601)),text: 'Signup as Organization'),
                ],
              ),
              // elevation: 0.0,
              // actions: <Widget>[
              //   IconButton(
              //     icon: Icon(Icons.search),
              //     iconSize: 30.0,
              //     color: Color(0xFFFC6601),
              //     onPressed: () {
              //       showSearch(context: context, delegate: Search(widget.list));
              //       // pref.logout();
              //       // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              //
              //     },
              //   ),
              // ],
              // title: Text('Techvertix Chat App'),
            ),

            body: Container(
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
              child: TabBarView(

              children: [
                Container(
                  child:SignupUser(),
                ),
                Container(
                  child:SignupCompany(),
                ),
              ],
              ),
            )
          ),
        )
    );
  }
}