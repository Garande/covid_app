import 'dart:convert' as convert;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:covid_app/utils/constants.dart';
import 'package:http/http.dart' as http;

import 'package:covid_app/models/map_marker.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapHelper {
  static const kGoogleApiKey = '';

  static const String markerImageUrl =
      'https://img.icons8.com/office/80/000000/marker.png';

  static const Color clusterColor = Colors.blue;

  static const Color clusterTextColor = Colors.white;

  //? CREATE LATLNG LIST
  static List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }

    return result;
  }

  //? DECODE POLY
  static List decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;

    /// Repeat process until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      /// Decode value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);

      // if value is negative then bitwise not the value
      if (result & 1 == 1) {
        result = ~result;
      }

      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    //! Add value to the previous value as done in encoding
    for (int i = 2; i < lList.length; i++) lList[1] += lList[i - 2];
  }

  static Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude}, ${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$kGoogleApiKey";

    http.Response response = await http.get(url);

    Map values = convert.jsonDecode(response.body);
    return values['routes'][0]['overview_polyline']['points'];
  }

  static Future<BitmapDescriptor> getMarkerImageFromUrl(
    String url, {
    int targetWidth,
  }) async {
    assert(url != null);

    final File markerImageFile = await DefaultCacheManager().getSingleFile(url);

    Uint8List markerImagesBytes = await markerImageFile.readAsBytes();

    if (targetWidth != null) {
      markerImagesBytes = await _resizeImageBytes(
        markerImagesBytes,
        targetWidth,
      );
    }

    return BitmapDescriptor.fromBytes(markerImagesBytes);
  }

  static Future<Uint8List> _resizeImageBytes(
      Uint8List imageBytes, int targetWidth) async {
    assert(imageBytes != null);
    assert(targetWidth != null);

    final Codec imageCodec = await instantiateImageCodec(
      imageBytes,
      targetWidth: targetWidth,
    );

    final FrameInfo frameInfo = await imageCodec.getNextFrame();

    final ByteData byteData = await frameInfo.image.toByteData(
      format: ImageByteFormat.png,
    );

    return byteData.buffer.asUint8List();
  }

  static Future<Fluster<MapMarker>> initClusterManager(
      List<MapMarker> markers, int minZoom, int maxZoom,
      {Function handleClusterOnTap}) async {
    assert(markers != null);
    assert(minZoom != null);
    assert(maxZoom != null);

    return Fluster<MapMarker>(
      minZoom: minZoom,
      maxZoom: maxZoom,
      radius: 150,
      extent: 2048,
      nodeSize: 64,
      points: markers,
      createCluster: (
        BaseCluster cluster,
        double lng,
        double lat,
      ) =>
          MapMarker(
        onTap: handleClusterOnTap,
        id: cluster.id.toString(),
        latitude: lat,
        longitude: lng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        isCluster: true,
        clusterId: cluster.id,
        pointsSize: cluster.pointsSize,
        childMarkerId: cluster.childMarkerId,
      ),
    );
  }

  static Future<List<Marker>> getClusterMarkers(
    Fluster<MapMarker> clusterManager,
    double currentZoom,
    Color clusterColor,
    Color clusterTextColor,
    int clusterWidth,
  ) {
    assert(currentZoom != null);
    assert(clusterColor != null);
    assert(clusterTextColor != null);
    assert(clusterWidth != null);

    if (clusterManager == null) return Future.value([]);

    return Future.wait(
      clusterManager.clusters([-180, -85, 180, 85], currentZoom.toInt()).map(
        (mapMarker) async {
          if (mapMarker.isCluster) {
            mapMarker.icon = await _getClusterMarker(
              mapMarker.pointsSize,
              clusterColor,
              clusterTextColor,
              clusterWidth,
            );
          }
          return mapMarker.toMarker();
        },
      ).toList(),
    );
  }

  static Future<BitmapDescriptor> _getClusterMarker(
    int clusterSize,
    Color clusterColor,
    Color textColor,
    int width,
  ) async {
    assert(clusterSize != null);
    assert(clusterColor != null);
    assert(width != null);

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = clusterColor;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final double radius = width / 2;

    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      paint,
    );

    textPainter.text = TextSpan(
      text: clusterSize.toString(),
      style: TextStyle(
        fontSize: radius - 5,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        radius - textPainter.width / 2,
        radius - textPainter.height / 2,
      ),
    );

    final image = await pictureRecorder.endRecording().toImage(
          radius.toInt() * 2,
          radius.toInt() * 2,
        );
    final data = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }
}
