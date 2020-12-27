import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {

  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var d = json.decode(prefs.getString(key));
    int len = d.length;
    List<String> l = [];
    for(int i =0; i< len; i++){
      l.add(d[i]);
    }
    return l;
  }

  reademail(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var d = json.decode(prefs.getString(key));
    return d;
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}