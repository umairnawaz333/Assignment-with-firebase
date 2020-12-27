import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homaworkmangement/Login.dart';
import 'package:smart_select/smart_select.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  String email,password,username,type,semester;
  DatabaseReference mDatabase;

  String value = '1';
  List<S2Choice<String>> options = [
    S2Choice<String>(value: '1', title: '1'),
    S2Choice<String>(value: '2', title: '2'),
    S2Choice<String>(value: '3', title: '3'),
    S2Choice<String>(value: '4', title: '4'),
    S2Choice<String>(value: '5', title: '5'),
    S2Choice<String>(value: '6', title: '6'),
    S2Choice<String>(value: '7', title: '7'),
    S2Choice<String>(value: '8', title: '8'),
  ];

  String valuea = 'Student';
  List<S2Choice<String>> optionsa = [
    S2Choice<String>(value: 'student', title: 'Student'),
    S2Choice<String>(value: 'teacher', title: 'Teacher'),
  ];


  void _validateRegisterInput() async {

    BuildContext dialogContext;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Row(
              children: [
                new CircularProgressIndicator(),
                SizedBox(width: 25.0,),
                new Text("Loading"),
              ],
            ),
          ),
        );
      },
    );

    try{
      await Firebase.initializeApp();
      UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      User user = result.user;
      await user.updateProfile(displayName: username);
      // user.sendEmailVerification();
      print(user);
      Navigator.pop(dialogContext);
      if(user != null){
        FirebaseFirestore _firestore = FirebaseFirestore.instance;
        DocumentReference ref = _firestore.collection('users').doc(user.email);
        ref.set({'UID': user.uid,'name': username,'account_type': type,'semester': semester});
        Navigator.of(context).pushReplacement(
            PageRouteBuilder(
                transitionDuration: Duration(seconds: 2),
                pageBuilder: (_, __, ___) => SignInScreen()
            )
        );
      }
      else{
        Fluttertoast.showToast(
            msg: "Something wrrong in information...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.tealAccent[800],
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
    catch(error){
      Navigator.pop(dialogContext);
      Fluttertoast.showToast(
          msg: error.code,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          BackButtonWidget(),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.person), onPressed: null),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: TextField(
                          onChanged: (value){
                            username = value;
                          },
                          decoration: InputDecoration(hintText: 'Username'),
                        )))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.email), onPressed: null),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: TextField(
                          onChanged: (value){
                            email = value;
                          },
                          decoration: InputDecoration(hintText: 'Email'),
                        )))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.lock), onPressed: null),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: TextField(
                          obscureText: true,
                          onChanged: (value){
                            password = value;
                          },
                          decoration: InputDecoration(hintText: 'Password'),
                        )))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.class_), onPressed: null),
                Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 20, left: 10),
                      child: SmartSelect<String>.single(
                          title: 'Account',
                          value: valuea,
                          choiceItems: optionsa,
                          onChange: (state) {
                            setState(() {
                              valuea = state.value;
                            });
                            type = state.value;
                          }
                      ),
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.class_), onPressed: null),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: SmartSelect<String>.single(
                            title: 'Semester',
                            value: value,
                            choiceItems: options,
                            onChange: (state) {
                              setState(() {
                                value = state.value;
                              });
                              semester = state.value;
                            }
                        ),
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 50,
                width: 150,
                child: RaisedButton(
                  onPressed: () {
                    _validateRegisterInput();
                  },
                  color: Colors.tealAccent[700],
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('images/app.png'))),
      child: Positioned(
          child: Stack(
        children: <Widget>[
          Positioned(
              top: 15,
              child: Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Text(
                    'Back',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              )),
          Positioned(
            bottom: 20,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Create New Account',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          )
        ],
      )),
    );
  }
}
