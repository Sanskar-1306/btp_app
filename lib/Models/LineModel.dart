import 'package:flutter/material.dart';
class cableModel{
  String id ="";
  String name ="";
  int rating=0;
  List<locationPoint> points=[];
  String startingLocation = "";
  String endingLocation = "";
  String nextMant = "";

  cableModel(this.id,this.name,this.rating,this.points,this.startingLocation,this.endingLocation,this.nextMant);
  factory cableModel.fromJson(Map<String,dynamic>json){
    List<locationPoint> listPoints =   new List<locationPoint>.from(json['point_locations'].map((p)=>locationPoint.fromJson(p)).toList());
    return cableModel(json['_id'],
        json['name'],
        json['rating'],
        listPoints,
        json['starting_location'],
        json['ending_location'],
        json['next_maintenance']);
  }

}
class locationPoint{
  int latitutde=0;
  int longitude=0;
  locationPoint(this.latitutde,this.longitude);

  factory locationPoint.fromJson(List<dynamic> json)
  {
    return locationPoint(json[0], json[1]);
  }
}
