import 'package:btp_app/Utilities/icon_from_image.dart';
import 'package:btp_app/widgets/image_gesture.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SubstationWidget extends StatefulWidget {
  const SubstationWidget({Key? key}) : super(key: key);

  @override
  State<SubstationWidget> createState() => _SubstationWidgetState();
}

class _SubstationWidgetState extends State<SubstationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: ImageGesture('assets/images/RMU.png',20,'RMU Information')),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ImageGesture('assets/images/transformer.png',120,'T1 Information'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ImageGesture('assets/images/transformer.png',120,'T2 Information'),
                ),

              ],
            ),
      ImageGesture('assets/images/LT_Panel.png',70,'LT Panel Information')
          ],
      ),
        )


    );
  }
}

