import 'dart:async';
import 'dart:typed_data';

import 'package:btp_app/Models/LineModel.dart';
import 'package:btp_app/Substation.dart';
import 'package:btp_app/Utilities/api_calls.dart';
import 'package:btp_app/Utilities/icon_from_image.dart';
import 'package:btp_app/coordinates.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  final List<Marker> _markers = <Marker>[];
  final Map<PolylineId,Polyline> _polylines = <PolylineId,Polyline>{};
  bool isPolyLineContinue = false;
  PolylineId currentPolylineId = PolylineId("id");


  static const CameraPosition _kBhawan = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(29.869858078101394, 77.89556176735142),
      zoom: 15.151926040649414);

  static const CameraPosition _kDept = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(29.863895988693088, 77.89736900562289),
      tilt: 59.440717697143555,
      zoom: 15.151926040649414);

  Future<Position> getCurrentLocation () async
  {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  // void loadMarkers()
  // {
  //   _markers.add(Marker(markerId: MarkerId("marker1"),
  //   position: LatLng(29.869858078101394, 77.89556176735142),
  //   draggable: true));
  //
  //   _markers.add(Marker(markerId: MarkerId("marker2"),
  //         position: LatLng(_kDept.target.latitude, _kDept.target.longitude),
  //         draggable: true),
  //     );
  //
  //   _polylines.add(Polyline(polylineId: PolylineId("line1"),
  //   points: [LatLng(_kBhawan.target.latitude, _kBhawan.target.longitude),
  //     LatLng(_kDept.target.latitude, _kDept.target.longitude)],
  //     color: Color(0xff00008B)
  //   ));
  // }
void animateToCurrent(Position currentLocation)async
{
  final GoogleMapController controller = await _controller.future;
  controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(currentLocation.latitude,
      currentLocation.longitude),zoom: 20)));
}
  void _addPoleMarker() async {

    Position currentLocation = await getCurrentLocation();
    final Uint8List customIcon =  await getBytesFromAsset(path: 'assets/images/substation.png', width: 120);
    setState(() {
      _markers.add(Marker(markerId: MarkerId("${currentLocation.latitude} "+"${currentLocation.longitude}"),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          draggable: true,
        icon: BitmapDescriptor.fromBytes(customIcon),
        onTap: (){
        _customInfoWindowController.addInfoWindow!(Column(
          children: [
            SubstationWidget(),

          ],
        ),LatLng(currentLocation.latitude, currentLocation.longitude));
        // showModalBottomSheet(context: context, builder: (context){
        //   return SubstationWidget();
        //
        // });
        }
      ));
    });
    animateToCurrent(currentLocation);

  }

 void _addPolyLinePoint() async
 {
   Position currentLocation = await getCurrentLocation();
   if (_polylines.isEmpty|| !isPolyLineContinue)
     {

       currentPolylineId = PolylineId("id: ${currentLocation.latitude} "+"${currentLocation.longitude}");
       PolylineId localPolyline = PolylineId("id: ${currentLocation.latitude} "+"${currentLocation.longitude}");
       print(currentPolylineId.value);
       _polylines[currentPolylineId]= (Polyline(polylineId: currentPolylineId,
         consumeTapEvents: true,
         width: 3,
         color: Colors.red,
         points: [],
         onTap: (){
         print("Local"+ "$localPolyline");
         print("current"+ "$currentPolylineId");
         handlePolylineClick(localPolyline);
         }
       ));
       isPolyLineContinue = true;

     }

   Polyline polyline = _polylines[currentPolylineId] as Polyline;
   _polylines.remove(polyline);
   polyline.points.add(LatLng(currentLocation.latitude,
       currentLocation.longitude));
   setState(() {
     _polylines[currentPolylineId] = polyline;
     print(_polylines[currentPolylineId]!.points);
   });
   animateToCurrent(currentLocation);

 }
void _addPolyLine() async{
 setState(() {
   print("polyline created");
   isPolyLineContinue = false;
    for (Polyline p in _polylines.values)
      {
        print(p.polylineId.value);
      }

 });

}

void handlePolylineClick(PolylineId polylineId)
{
  Polyline newPolyLine = _polylines[polylineId]!.copyWith(colorParam: Colors.blue);
  setState(() {
    _polylines[polylineId]= newPolyLine;
  });
  _customInfoWindowController.addInfoWindow!(
      Container(
        color: Colors.white,
        child: Center(child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("${polylineId.value}"),
        )),
      ),LatLng(newPolyLine.points[0].latitude,newPolyLine.points[0].longitude )
  );
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // getCableData();
    //getSubstationData();
    createCable(cableModel("id", "harhschutiya", 69, [locationPoint(0, 0),locationPoint(1, 1)], "Pitampura", "Spa", "1-1-2024", 2001));
    PolylineId newPolylineId = PolylineId("id1");
    _polylines [newPolylineId] =(Polyline(polylineId: newPolylineId,
    consumeTapEvents: true,
    width: 3,
    color: Colors.red,
    points: [LatLng(29.869858078101394, 77.89556176735142),
      LatLng(29.863895988693088, 77.89736900562289),],
      onTap: (){
          print("clicked on line");
          handlePolylineClick(newPolylineId);

      },


    ));

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: _kBhawan,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onTap: (position) {
                    _customInfoWindowController.hideInfoWindow!();
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                  },
                  onMapCreated: (GoogleMapController controller) async {
                    _customInfoWindowController.googleMapController = controller;
                  },
                  markers: Set<Marker>.of(_markers),
                  polylines: Set<Polyline>.of(_polylines.values),
                ),
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 300,
                  width: 320,
                  offset: 50,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(onPressed: (){
                      _addPolyLinePoint();
                },
                    child: Text("${(isPolyLineContinue)?"Add point":"New line"}")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(onPressed: (){
                  _addPoleMarker();
                }, child: Text("Add a pole")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: (isPolyLineContinue)?FilledButton(onPressed: (){
                  _addPolyLine();
                }, child: Text("Create")):null,
              ),
            ],
          )
        ],

      ),


    );
  }

  Future<void> _goToTheBhawan() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kBhawan));
  }
}
