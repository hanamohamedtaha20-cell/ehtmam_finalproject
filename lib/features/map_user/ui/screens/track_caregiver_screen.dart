import 'dart:async';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/eta_banner.dart';
import '../widgets/caregiver_info_card.dart';
import '../widgets/location_details.dart';

class TrackCaregiverScreen extends StatefulWidget {
  final String caregiverName;
  final String speciality;
  final String phoneNumber;
  final String userLocation;
  final String bookingId;

  const TrackCaregiverScreen({
    super.key,
    required this.caregiverName,
    required this.speciality,
    required this.phoneNumber,
    required this.userLocation,
    required this.bookingId,
  });

  @override
  State<TrackCaregiverScreen> createState() => _TrackCaregiverScreenState();
}

class _TrackCaregiverScreenState extends State<TrackCaregiverScreen> {
  static const LatLng _defaultCaregiver = LatLng(30.0500, 31.2400);
  static const LatLng _defaultUser      = LatLng(30.0444, 31.2357);

  LatLng _caregiverLocation = _defaultCaregiver;
  String _lastUpdated = '';
  bool _loading = true;

  final _api = ApiService();
  final _mapController = MapController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchLocation());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    if (widget.bookingId.isEmpty) return;
    try {
      final response = await _api.getCaregiverLocation(widget.bookingId);
      final data = response['data'];
      if (data is Map) {
        final lat = (data['latitude']  as num?)?.toDouble();
        final lng = (data['longitude'] as num?)?.toDouble();
        final updated = data['lastUpdated']?.toString() ?? '';
        if (lat != null && lng != null && mounted) {
          setState(() {
            _caregiverLocation = LatLng(lat, lng);
            _lastUpdated = updated;
            _loading = false;
          });
          _mapController.move(_caregiverLocation, 14);
        }
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
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
          "Track Caregiver",
          style: TextStyle(
            fontFamily: "Arimo",
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: Colors.black,
          ),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const ETABanner(eta: "—", distance: "—"),
                SizedBox(
                  height: 250.h,
                  child: Padding(
                    padding: EdgeInsets.all(16.0.r),
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _caregiverLocation,
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
                              point: _caregiverLocation,
                              width: 40.w,
                              height: 40.h,
                              child: Icon(
                                Icons.location_pin,
                                color: Colors.green,
                                size: 40.r,
                              ),
                            ),
                            Marker(
                              point: _defaultUser,
                              width: 40.w,
                              height: 40.h,
                              child: Icon(
                                Icons.person_pin_circle,
                                color: Color(0xFF3A8BD7),
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
                        CaregiverInfoCard(
                          name: widget.caregiverName.isEmpty
                              ? "Caregiver"
                              : widget.caregiverName,
                          speciality: widget.speciality.isEmpty
                              ? "Care Service"
                              : widget.speciality,
                          rating: "4.8",
                          reviewCount: "99",
                          status: "On the way",
                          statusSubtitle:
                              "Caregiver is heading to your location",
                          phoneNumber: widget.phoneNumber.isEmpty
                              ? "-"
                              : widget.phoneNumber,
                        ),
                        SizedBox(height: 12.h),
                        LocationDetails(
                          userLocation: widget.userLocation.isEmpty
                              ? "Your Location"
                              : widget.userLocation,
                          caregiverLocation: "Caregiver's location",
                          distance: "—",
                          eta: "—",
                        ),
                        if (_lastUpdated.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Text(
                            'Last updated: ${_formatUpdated(_lastUpdated)}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _formatUpdated(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      final s = dt.second.toString().padLeft(2, '0');
      return '$h:$m:$s';
    } catch (_) {
      return iso;
    }
  }
}
