import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Event extends StatefulWidget {
  final DateTime choosenDate;
  Event (this.choosenDate );
  @override
  _EventState createState() => _EventState(choosenDate);
}

class _EventState extends State<Event> {
  final DateTime choosenDate;
  _EventState(this.choosenDate);
  final eventsRef = Firestore.instance.collection("events");
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Events on ${choosenDate.day}-${choosenDate.month} '),
      ),
      body: FutureBuilder<QuerySnapshot>(
        // gets events before end date
        future: eventsRef.where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(choosenDate)).getDocuments(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          List events=[];
          snapshot.data.documents.forEach((element) { 
            // to get events before end date
           if(element.data['endDate'].toDate().isAfter(choosenDate)){
            events.add(element.data); 
          } 
          });
           if(events.length==0){
            return Center(child: Text('No Events Available :('));
          }
          else
          return ListView.builder(
        itemCount: events.length,
        itemBuilder: (BuildContext context, index){
         return ListTile(
            contentPadding:  EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            title:  Text(events[index]['name']),
            subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      );
        },
      ),
    );
  }
}