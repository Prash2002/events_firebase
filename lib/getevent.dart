import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Event extends StatefulWidget {
  final DateTime choosenDate;
  // Event(this.choosenDate);
  Event (this.choosenDate );
  @override
  _EventState createState() => _EventState(choosenDate);
}

class _EventState extends State<Event> {
  final DateTime choosenDate;
  _EventState(this.choosenDate);
  final eventsRef = Firestore.instance.collection("events");
  final List endArray = [];
  final List events = [];
  String eventName;
  @override
  void initState(){
    super.initState();
    getEvent(choosenDate);
  }

  getEvent(DateTime choosenDate) async{
    final QuerySnapshot endsBefore = await 
    eventsRef
    .where('endDate', isGreaterThanOrEqualTo: Timestamp.fromDate(choosenDate))
    .getDocuments();
    final QuerySnapshot startsAfter = await 
    eventsRef
    .where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(choosenDate))
    .getDocuments();
    endsBefore.documents.forEach(
      (element) {
        endArray.add(element.documentID);
      }
    );
    startsAfter.documents.forEach(
      (element) {
        endArray.forEach((id) {
          if(id==element.documentID){
            print(element.documentID);
            setState((){
              eventName = element.data['name'];
            });
            print(eventName);
            events.add(element.data);
          }
         });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events on ${choosenDate.day}-${choosenDate.month} '),
      ),
      body: events.length==0? Center(child: Text('No Events available :(')):ListView.builder(
        itemCount: events.length,
        itemBuilder: (BuildContext context, index){
          print(events[index]);
          return ListTile(
            contentPadding:  EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            title:  Text(events[index]['name']),
            
            subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Start Date: ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(events[index]['startDate'].toDate().toString()),
                      ],
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Row(
                      children: <Widget>[
                        Text('End Date: ',style: TextStyle(fontWeight: FontWeight.w500),),
                        Text(events[index]['endDate'].toDate().toString()),
                      ],
                    ),
                  ),
                ],
              ),
            
          );
        },
      )
    );
  }
}