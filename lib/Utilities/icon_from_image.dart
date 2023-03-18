import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

Future<Uint8List> getBytesFromAsset({required String path,required int width})async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width
  );
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png))!
      .buffer.asUint8List();
}
