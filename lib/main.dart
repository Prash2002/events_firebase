// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'getevent.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime selectedDate = DateTime.now();
  Future<void> datePicker(BuildContext context) async{
    final DateTime choosen = await showDatePicker(
      context: context, 
      initialDate: selectedDate, 
      firstDate: DateTime(2002,7), 
      lastDate: DateTime(2100,7));
      if(choosen!=null && choosen!= selectedDate){
        setState(() {
          selectedDate = choosen;
        });
      }
      print(selectedDate.toLocal().toString().split(' ')[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("${selectedDate.toLocal()}".split(' ')[0]),
            SizedBox(height: 20.0,),
            RaisedButton(
              onPressed: () => datePicker(context),
              child: Text('Select date'),
            ),
            RaisedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Event(selectedDate)),),
              child: Text('Get Events'),
            ),
          ],
        ),
      ),
     
    );
  }
}