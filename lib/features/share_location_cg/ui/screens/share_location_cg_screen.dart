import 'dart:async';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/location_status_banner.dart';
import '../widgets/client_info_card.dart';
import '../widgets/location_details_cg.dart';

class ShareLocationCgScreen extends StatefulWidget {
  final String bookingId;
  final String clientName;
  final String serviceType;

  const ShareLocationCgScreen({
    super.key,
    required this.bookingId,
    this.clientName = '',
    this.serviceType = '',
  });

  @override
  State<ShareLocationCgScreen> createState() => _ShareLocationCgScreenState();
}

class _ShareLocationCgScreenState extends State<ShareLocationCgScreen> {
  static const LatLng _defaultLocation = LatLng(30.0500, 31.2400);

  LatLng _myLocation = _defaultLocation;
  bool _isSharing = false;
  bool _locationReady = false;
  String _errorMessage = '';
  String _clientName = '';
  String _serviceType = '';

  final _api = ApiService();
  final _mapController = MapController();
  Timer? _shareTimer;

  @override
  void initState() {
    super.initState();
    _clientName = widget.clientName;
    _serviceType = widget.serviceType;
    _initLocation();
    if (_clientName.isEmpty) _loadClientName();
  }

  @override
  void dispose() {
    _shareTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadClientName() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _clientName = prefs.getString('user_name') ?? 'Client';
      });
    }
  }

  Future<void> _initLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() => _errorMessage = 'Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) setState(() => _errorMessage = 'Location permission denied.');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) setState(() => _errorMessage = 'Location permission permanently denied. Enable it in settings.');
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      if (mounted) {
        setState(() {
          _myLocation = LatLng(pos.latitude, pos.longitude);
          _locationReady = true;
        });
        _mapController.move(_myLocation, 14);
      }
    } catch (e) {
      if (mounted) setState(() => _errorMessage = 'Could not get location.');
    }
  }

  void _toggleSharing() {
    if (!_locationReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Waiting for GPS location...')),
      );
      return;
    }

    if (_isSharing) {
      _shareTimer?.cancel();
      setState(() => _isSharing = false);
    } else {
      setState(() => _isSharing = true);
      _sendLocation(); // send immediately
      _shareTimer = Timer.periodic(
        const Duration(seconds: 10),
        (_) => _sendLocation(),
      );
    }
  }

  Future<void> _sendLocation() async {
    if (widget.bookingId.isEmpty) return;
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      if (mounted) {
        setState(() => _myLocation = LatLng(pos.latitude, pos.longitude));
        _mapController.move(_myLocation, 14);
      }
      await _api.updateCaregiverLocation(
        bookingId: widget.bookingId,
        latitude: pos.latitude,
        longitude: pos.longitude,
      );
    } catch (_) {
      // Silent — keep trying on the next tick.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Share Location",
          style: TextStyle(
            fontFamily: "Arimo",
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          LocationStatusBanner(
            eta: '—',
            distance: '—',
            isSharing: _isSharing,
          ),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 13.sp),
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(
            height: 220.h,
            child: Padding(
              padding: EdgeInsets.all(16.0.r),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _myLocation,
                  initialZoom: 14,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.ehtemam',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _myLocation,
                        width: 40.w,
                        height: 40.h,
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.green,
                          size: 40.r,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClientInfoCard(
                    name: _clientName.isEmpty ? 'Client' : _clientName,
                    serviceType: _serviceType.isEmpty ? 'Care Service' : _serviceType,
                    status: _isSharing ? 'Sharing location' : 'Not sharing',
                    statusSubtitle: _isSharing
                        ? 'Client can see your location'
                        : 'Start sharing so the client can track you',
                    isSharing: _isSharing,
                    onShareToggle: _toggleSharing,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Location Details",
                    style: TextStyle(
                      fontFamily: "Arimo",
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  LocationDetailsCg(
                    clientLocation: 'Client location',
                    caregiverLocation: _locationReady
                        ? '${_myLocation.latitude.toStringAsFixed(4)}, ${_myLocation.longitude.toStringAsFixed(4)}'
                        : 'Fetching…',
                    distance: '—',
                    eta: '—',
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    margin: EdgeInsets.all(8.r),
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(55, 0, 0, 0),
                          blurRadius: 6.r,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.circle, color: Colors.blue, size: 10.r),
                            SizedBox(width: 4.w),
                            Text(
                              "Privacy Notice",
                              style: TextStyle(
                                fontFamily: "Arimo",
                                fontSize: 13.sp,
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Your location is only shared with the client while sharing is active. You can stop at any time.',
                          style: TextStyle(
                            fontFamily: "Arimo",
                            fontSize: 13.sp,
                            color: Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
