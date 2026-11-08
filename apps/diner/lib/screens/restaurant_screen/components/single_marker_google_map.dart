import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SingleMarkerGMap extends StatefulWidget {
  final LatLng markerPosition;

  const SingleMarkerGMap({super.key, required this.markerPosition});
  @override
  State<SingleMarkerGMap> createState() => _SingleMarkerGMapState();
}

class _SingleMarkerGMapState extends State<SingleMarkerGMap> {
  final Set<Marker> _markers = {};

  void _addMarker(LatLng place) {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('single_marker'),
        position: widget.markerPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
    );
  }

  final Completer<GoogleMapController> _gMapController = Completer();
  String? _mapStyle;

  void _onMapCreated(GoogleMapController controller) {
    _gMapController.complete(controller);
  }

  @override
  void initState() {
    _addMarker(widget.markerPosition);
    _loadMapStyle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 21 / 10,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.markerPosition,
            zoom: 15,
          ),
          myLocationButtonEnabled: false,
          myLocationEnabled: false,
          onMapCreated: _onMapCreated,
          style: _mapStyle,
          markers: _markers,
          scrollGesturesEnabled: false,
          zoomGesturesEnabled: false,
        ),
      ),
    );
  }

  Future<void> _loadMapStyle() async {
    final mapStyle = await rootBundle.loadString(
      'assets/map_style/map_style_silver.json',
    );
    if (mounted) {
      setState(() => _mapStyle = mapStyle);
    }
  }
}
