import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homaworkmangement/Login.dart';
import 'package:homaworkmangement/SharedPref.dart';
import 'package:homaworkmangement/assignmentlist.dart';
import 'dart:async';
import 'Registration.dart';

void main() {
  runApp(SplashScreen());
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Splach(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Splach extends StatefulWidget {
  @override
  _SplachState createState() => _SplachState();
}

class _SplachState extends State<Splach> {
  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    super.initState();
    check_email();
  }

  void check_email() async{
    String e;
    try {
      e = await sharedPref.reademail("email");
    }
    catch(error){
      print(error);
    }

    print(e);
    if(e != null){
      Timer(Duration(seconds: 3), (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => assignmentlist(),
        ));
      });
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Notifi()));
    }
    else{
      Timer(Duration(seconds: 4), (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(child: BackButtonWidget()),
          ],
        ),
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
      height: 400,
      width: double.infinity,
      child: Image.asset("images/app.png", fit: BoxFit.fill,),
    );
  }
}
