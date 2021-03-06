import 'package:firebasetodo/createevent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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
  datePicker(BuildContext context){
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true, 
      minTime: DateTime(2020, 1, 1),
      maxTime: DateTime(2025, 12, 31),
      onConfirm: (date) {
        setState(() {
        selectedDate = date;
        });
      },
      );
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
            RaisedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateEvent())),
              child: Text('Create Event'),
            ),
            SizedBox(height: 20.0,),
            Text(selectedDate.toLocal().toString()),
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