import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _form = GlobalKey<FormState>();
  String eventName;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  DateTime arrayDate = DateTime.now();
  
  final eventsRef = Firestore.instance.collection("events");
  List eventDates=[];

  createEventinFirebase() async{
      await eventsRef.add({
        'name': eventName,
        'eventDates': eventDates,
      });
  }
  
  startDatePicker(BuildContext context){
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true, 
      minTime: DateTime(2020, 1, 1),
      maxTime: DateTime(2025, 12, 31),
      onConfirm: (date) {
        setState(() {
        startDate = date;
        });
      },
      );
  }
  endDatePicker(BuildContext context){
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true, 
      minTime: DateTime(2020, 1, 1),
      maxTime: DateTime(2025, 12, 31),
      onConfirm: (date) {
        setState(() {
        endDate = date;
        });
      },
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event')
      ),
      body: Form(
        key: _form,
        child: Column(
          children: <Widget>[
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter Event Name',
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                  ),
                )),
                onSaved: (newValue) {
                  setState(() {
                    eventName = newValue;
                  });
                  print(eventName);
                },
                // autovalidate: true,
                validator: (value) {
                  if(value.isEmpty){
                    return 'Please Enter the Event Name';
                  }
                  else return null;
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(startDate.toLocal().toString().split(' ')[0]),
                    SizedBox(height: 20.0,),
                    RaisedButton(
                      onPressed: () => startDatePicker(context),
                      child: Text('Select Start date'),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(endDate.toLocal().toString().split(' ')[0]),
                    SizedBox(height: 20.0,),
                    RaisedButton(
                      onPressed: () => endDatePicker(context),
                      child: Text('Select End date'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            RaisedButton(onPressed: () async{
                _form.currentState.save();
                if (_form.currentState.validate()){
                  // print(eventName);
                  // print(startDate);
                  // print(endDate);
                  arrayDate= startDate;
                  eventDates.add(arrayDate);
                  for(int i=startDate.day; i< endDate.day; i++){
                    arrayDate=arrayDate.add(Duration(days: 1));
                    eventDates.add(arrayDate);
                  }
                  print(eventDates);
                  await createEventinFirebase();
                  Navigator.pop(context);
                }
              },
              child: Text('Submit'),
            )
          ],
        ),
      )
    );
  }
}