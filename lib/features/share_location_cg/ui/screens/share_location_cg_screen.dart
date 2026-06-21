import 'dart:async';
import 'package:ehtemam_final_project/core/services/location_socket_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/location_status_banner.dart';
import '../widgets/client_info_card.dart';
import '../widgets/location_details_cg.dart';
import 'package:ehtemam_final_project/features/myTasks_caregiver/ui/screens/mytask_cg_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class ShareLocationCgScreen extends StatefulWidget {
  final String bookingId;
  final String clientName;
  final String serviceType;
  final double clientRating;

  const ShareLocationCgScreen({
    super.key,
    required this.bookingId,
    this.clientName = '',
    this.serviceType = '',
    this.clientRating = 0,
  });

  @override
  State<ShareLocationCgScreen> createState() => _ShareLocationCgScreenState();
}

class _ShareLocationCgScreenState extends State<ShareLocationCgScreen> {
  static const LatLng _defaultLocation = LatLng(30.0444, 31.2357);

  LatLng _myLocation = _defaultLocation;
  bool _isSharing = false;
  String _errorMessage = '';
  String _clientName = '';
  String _serviceType = '';
  double _clientRating = 0;

  final _socket = LocationSocketService();
  final _mapController = MapController();
  Timer? _shareTimer;

  @override
  void initState() {
    super.initState();
    _clientName = widget.clientName;
    _serviceType = widget.serviceType;
    _clientRating = widget.clientRating;
    _loadFallbacks();
    debugPrint('CLIENT_NAME: $_clientName');
    debugPrint('CLIENT_RATING: $_clientRating');
    debugPrint('SERVICE_NAME: $_serviceType');
  }

  @override
  void dispose() {
    _shareTimer?.cancel();
    _socket.disconnect();
    super.dispose();
  }

  Future<void> _loadFallbacks() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        if (_clientName.isEmpty) _clientName = prefs.getString('user_name') ?? 'Client';
        if (_serviceType.isEmpty) {
          _serviceType = prefs.getString('care_field') ?? '';
          debugPrint('SERVICE_NAME (from prefs care_field): $_serviceType');
        }
      });
    }
  }

  // ── Permission ─────────────────────────────────────────────────────────────

  Future<bool> _requestLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => _errorMessage = 'Location services are disabled. Please enable GPS.');
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => _errorMessage = 'Location permission denied.');
      return false;
    }
    return true;
  }

  // ── Toggle sharing ─────────────────────────────────────────────────────────

  Future<void> _toggleSharing() async {
    if (_isSharing) {
      _shareTimer?.cancel();
      _socket.disconnect();
      if (mounted) setState(() { _isSharing = false; _errorMessage = ''; });
      return;
    }

    // Guard: never start sharing with an empty bookingId — the backend would
    // receive a POST to /booking//location (404) and nothing would be saved.
    if (widget.bookingId.isEmpty) {
      debugPrint('JOIN_BOOKING_FAILED: bookingId is empty');
      if (mounted) setState(() => _errorMessage = 'Booking ID is missing. Cannot share location.');
      return;
    }

    final hasPermission = await _requestLocationPermission();
    if (!hasPermission) return;

    if (mounted) setState(() { _isSharing = true; _errorMessage = ''; });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    debugPrint('CAREGIVER_BOOKING_ID = ${widget.bookingId}');

    // connect() handles join_booking INSIDE onConnect so the order is always:
    //   socket connects → join_booking → first location send
    _socket.connect(
      token: token,
      bookingId: widget.bookingId,
      onConnected: _sendLocation,
      onConnectError: (message) {
        _shareTimer?.cancel();
        final isBlocked = message.toLowerCase().contains('blocked');
        if (mounted) {
          setState(() {
            _isSharing = false;
            _errorMessage = isBlocked
                ? 'Your account has been blocked. Please contact support.'
                : 'Connection failed: $message';
          });
        }
      },
    );

    // Timer for subsequent sends (socket is connected by the time these fire)
    _shareTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _sendLocation(),
    );

    if (widget.bookingId.isNotEmpty) {
      await prefs.setBool('loc_shared_${widget.bookingId}', true);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('location_sharing_started'.tr(),
        ),
        duration: const Duration(seconds: 6),
        action: SnackBarAction(
          label: 'View Tasks',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MytaskCgScreen(bookingId: widget.bookingId),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Send location ──────────────────────────────────────────────────────────

  Future<void> _sendLocation() async {
    if (widget.bookingId.isEmpty) {
      debugPrint('[ShareLoc] bookingId is empty — skipping send');
      return;
    }

    debugPrint('CAREGIVER_BOOKING_ID = ${widget.bookingId}');

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10), // prevent infinite hang on weak GPS
        ),
      );
      final lat = position.latitude;
      final lng = position.longitude;

      debugPrint('GPS_LAT: $lat');
      debugPrint('GPS_LNG: $lng');

      // Update map marker with real position
      if (mounted) {
        setState(() => _myLocation = LatLng(lat, lng));
        _mapController.move(LatLng(lat, lng), 14);
      }

      // Emit live update via Socket.IO (only if connected — join_booking already sent)
      _socket.emitLocationUpdate(
        bookingId: widget.bookingId,
        lat: lat,
        lng: lng,
      );

      if (mounted && _errorMessage.isNotEmpty) {
        setState(() => _errorMessage = '');
      }
    } catch (e) {
      debugPrint('[ShareLoc] GPS_ERROR: $e');
      if (mounted) setState(() => _errorMessage = 'Failed to get GPS position.');
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('share_location'.tr(),
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
                    serviceType:
                        _serviceType.isEmpty ? 'Care Service' : _serviceType,
                    clientRating: _clientRating,
                    status:
                        _isSharing ? 'Sharing location' : 'Not sharing',
                    statusSubtitle: _isSharing
                        ? 'Client can see your location'
                        : 'Start sharing so the client can track you',
                    isSharing: _isSharing,
                    onShareToggle: _toggleSharing,
                  ),
                  SizedBox(height: 16.h),
                  Text('location_details'.tr(),
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
                    caregiverLocation:
                        '${_myLocation.latitude.toStringAsFixed(4)}, ${_myLocation.longitude.toStringAsFixed(4)}',
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
                          color: const Color.fromARGB(55, 0, 0, 0),
                          blurRadius: 6.r,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.circle,
                                color: Colors.blue, size: 10.r),
                            SizedBox(width: 4.w),
                            Text('privacy_notice'.tr(),
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
