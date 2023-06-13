import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_maps/data_dummy.dart';
import 'package:flutter_google_maps/model/map_type_google.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapsV2Page extends StatefulWidget {
  const MapsV2Page({Key? key}) : super(key: key);

  @override
  State<MapsV2Page> createState() => _MapsV2PageState();
}

class _MapsV2PageState extends State<MapsV2Page> {
  double latitude = -6.195122668718907;
  double longitude = 106.79491536669765;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  var mapType = MapType.normal;
  Position? devicePosition;
  String? address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Maps V2"),
        actions: [
          PopupMenuButton(
              onSelected: onSelectedMapType,
              itemBuilder: (context) {
                return googleMapTypes.map((typeGoogle) {
                  return PopupMenuItem(
                      value: typeGoogle.type,
                      child: Text(typeGoogle.type.name));
                }).toList();
              })
        ],
      ),
      body: Stack(
        children: [
          // GOOGLE MAPS
          _buildMaps(),
          // CARD TEMPAT
          _buildSearchCard(),
          // _buildDetailCard()
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestLocationPermission();
  }

  Future requestLocationPermission() async {
    await Permission.location.request();
  }

  Widget _buildMaps() {
    return GoogleMap(
      mapType: mapType,
      initialCameraPosition: CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 17,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  void onSelectedMapType(Type value) {
    setState(() {
      switch (value) {
        case Type.Normal:
          mapType = MapType.normal;
          break;
        case Type.Hybrid:
          mapType = MapType.hybrid;
          break;
        case Type.Terrain:
          mapType = MapType.terrain;
          break;
        case Type.Satellite:
          mapType = MapType.satellite;
          break;
        default:
      }
    });
  }

  _buildSearchCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 150,
        width: double.infinity,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(10),
          child: Column(
            children: [
              // field pencarian

              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 8, bottom: 4),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Masukkan alamat...',
                      contentPadding: const EdgeInsets.only(left: 15, top: 15),
                      suffixIcon: IconButton(
                        onPressed: searchLocation,
                        icon: const Icon(Icons.search),
                      )),
                  onChanged: (value) {
                    address = value;
                  },
                ),
              ),

              // tombol untuk mendapatkan posisi device
              ElevatedButton(
                  onPressed: () {
                    getCurrentPosition().then((value) async {
                      setState(() {
                        devicePosition = value;
                      });
                      GoogleMapController controller = await _controller.future;
                      LatLng target = LatLng(value!.latitude, value.longitude);
                      CameraPosition cameraPosition =
                          CameraPosition(target: target, zoom: 17);
                      CameraUpdate cameraUpdate =
                          CameraUpdate.newCameraPosition(cameraPosition);
                      controller.animateCamera(cameraUpdate);
                    });
                  },
                  child: const Text("Dapatkan lokasi saat ini")),

              // teks latitude dan longitude
              devicePosition == null
                  ? const Text("Lokasi belum terdeteksi")
                  : Text(
                      "Lokasi saat ini : ${devicePosition!.latitude},${devicePosition!.longitude}")
            ],
          ),
        ),
      ),
    );
  }

  Future<Position?> getCurrentPosition() async {
    Position? currentPosition;

    try {
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentPosition = null;
    }
    return currentPosition;
  }

  Future searchLocation() async{
    try {
      await GeocodingPlatform.instance
          .locationFromAddress(address!).then((value) async {
            GoogleMapController controller = await _controller.future;
            LatLng target = LatLng(value[0].latitude, value[0].longitude);
            CameraPosition cameraPosition = CameraPosition(target: target, zoom: 17);
            CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition);
            controller.animateCamera(cameraUpdate);
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Lokasi tidak ditemukan");
    }
  }
}
