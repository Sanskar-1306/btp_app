import 'package:flutter/material.dart';

class ImageGesture extends StatelessWidget {
 String asset;
 double height;
 String id;
   ImageGesture(this.asset,this.height,this.id);

@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: (){
      showModalBottomSheet(context: context, builder: (context){
        return Container(child: Center(
          child: Text(this.id),
        ),);
      });
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Image.asset(asset,
        height: this.height,),
    ),
  );
}
}
