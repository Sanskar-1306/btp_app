import 'dart:convert';

import 'package:btp_app/Models/LineModel.dart';
import 'package:btp_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
Future<List<cableModel>> getCableData() async
{
  print("getting cables");
    http.Response response = await http.get(Uri.parse('$baseUrl/cables'));
    if (response.statusCode==200)
      {
        var data = jsonDecode(response.body);
        print(data);
        List<cableModel> cabels =[];
        for (var d in data['data'])
          {
            print("d= $d");
            cableModel newCable = cableModel.fromJson(d);
            cabels.add(newCable);
          print(newCable.nextMant);
          }

      return cabels;
      }

    throw Exception("failed to load cables");

}

void createCable(cableModel cable) async
{
  print("creating cable");
  var body = cable.toJson();
  print(jsonEncode(body));

  try{
  http.Response response = await http.post(Uri.parse('$baseUrl/cables/createcable'),body:
  jsonEncode(body),headers: {'Content-Type':'application/json'}
  );
  print(response.body);
}

catch(e){
  print(e);
}
}

void updateCable(cableModel cable)async{
  print("creating cable");
  var body = cable.toJson();
  print(jsonEncode(body));

  try{
    http.Response response = await http.patch(Uri.parse('$baseUrl/cables/cable/${cable.id}/'),body:
    jsonEncode(body),headers: {'Content-Type':'application/json'});
    print(response.body);
  }

  catch(e){
    print(e);
  }

}

void getSubstationData() async
{
  http.Response response = await http.get(Uri.parse('$baseUrl/substations'));
  if (response.statusCode==200)
    {
      var data = jsonDecode(response.body);
      print(data);
    }

}