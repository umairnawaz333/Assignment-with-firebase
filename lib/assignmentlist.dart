import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homaworkmangement/SharedPref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class assignmentlist extends StatefulWidget {
  @override
  _assignmentlistState createState() => _assignmentlistState();
}

class _assignmentlistState extends State<assignmentlist> {
  SharedPref sharedPref = SharedPref();
  String email, username;
  String semester, type, subject;
  String _fname, myfilename,fileName;
  File file;
  List l = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getfiledata();
    getdata();
    setState(() {

    });
    _fname = "";
  }

  getfiledata()async{
    await Firebase.initializeApp();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    CollectionReference ref = _firestore.collection("assignment");
    QuerySnapshot userRef = await ref.get();
    l = userRef.docs.toList();
    print(l);
    setState(() {

    });
  }

  getdata() async {
    try{
      email = await sharedPref.reademail("email");
      type = await sharedPref.reademail("type");
      semester = await sharedPref.reademail("semester");
    }
    catch(error){
      print("error----"+error);
    }
    print("---"+email+" "+type+" "+semester);
  }

  Future getFile() async {
    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }
    file = await FilePicker.getFile(
        type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);
    fileName = '${randomName}';

    setState(() {
      _fname = file.path;
    });
    print('${file.readAsBytesSync()}');
  }

  Future savePdf(List<int> asset) async {
    await Firebase.initializeApp();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putData(asset);

    String url = await (await uploadTask.whenComplete(() => null)).ref
        .getDownloadURL();
    print(url);
    documentFileUpload(url);
    return url;
  }

  void documentFileUpload(String str) {
    var data = {
      "type": type,
      "email": email,
      "filename" : myfilename,
      "file": str,
      "datetime": DateFormat('yyyy-MM-dd \t kk:mm:ss').format(DateTime.now()).toString(),
    };
    // DatabaseReference mainReference = FirebaseDatabase.instance.reference().child('Database');
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentReference ref = _firestore.collection("assignment").doc(subject);
    ref.set(data).then((v) {
      Fluttertoast.showToast(
          msg: "Uploaded file",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_LEFT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      getfiledata();
    });
  }

  Widget filenamebox(String filename,String subject,String date,String link) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: Colors.teal,)
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("file: "+ filename, textAlign: TextAlign.left,),
              Expanded(child: Text(date, textAlign: TextAlign.right,)),
            ],
          ),
          Row(
            children: [
              Text("Subject: "+subject, textAlign: TextAlign.left,),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("upload Assignment"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Center(
                      child: Container(
                          margin: EdgeInsets.only(right: 20, left: 10),
                          child: TextField(
                            onChanged: (value){
                              subject = value;
                            },
                            decoration: InputDecoration(hintText: 'Subject Name*'),
                          )),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 50,
                          width: 150,
                          child: RaisedButton(
                            onPressed: () {
                              getFile();
                            },
                            color: Colors.tealAccent[700],
                            child: Text(
                              'Select file',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Center(
                      child: Container(
                        child: Text(
                          "Path : "+
                          _fname
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                          margin: EdgeInsets.only(right: 20, left: 10),
                          child: TextField(
                            onChanged: (value){
                              myfilename = value;
                            },
                            decoration: InputDecoration(hintText: 'FileName*'),
                          )),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Center(
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 50,
                            width: 150,
                            child: RaisedButton(
                              onPressed: () {
                                if(subject == "" || myfilename == "" || _fname == ""){
                                  Fluttertoast.showToast(
                                      msg: "Enter Required Field",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }
                                else
                                  savePdf(file.readAsBytesSync());
                              },
                              color: Colors.tealAccent[700],
                              child: Text(
                                'Uplaod',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: Container(
                  child: Text(
                      "Uploaded List",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: Center(
                  child: (l.length > 0)
                      ? ListView.builder(
                    itemCount: l.length,
                    itemBuilder: (context, index) {
                        if(l[index].get("email") == email && l[index].get("type") == "teacher") {
                          return filenamebox(
                              l[index].get("filename"), l[index].id,
                              l[index].get("datetime"), l[index].get("file")
                          );
                        }
                        return null;
                    },
                  )
                      :
                  Container(child: Text('No assignment'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
