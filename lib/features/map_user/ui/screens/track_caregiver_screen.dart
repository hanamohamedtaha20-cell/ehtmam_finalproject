import 'package:ehtemam_final_project/features/map_user/data/repo/track_caregiver_repo.dart';
import 'package:ehtemam_final_project/features/map_user/manager/track_caregiver_cubit.dart';
import 'package:ehtemam_final_project/features/map_user/manager/track_caregiver_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/eta_banner.dart';
import '../widgets/caregiver_info_card.dart';
import '../widgets/location_details.dart';

// ── API-key placeholders ────────────────────────────────────────────────────
// If you ever switch from flutter_map to google_maps_flutter, add the key here:
//
//   Android  →  android/app/src/main/AndroidManifest.xml
//               inside <application>:
//               <meta-data android:name="com.google.android.geo.API_KEY"
//                          android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
//
//   iOS      →  ios/Runner/AppDelegate.swift
//               GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
// ───────────────────────────────────────────────────────────────────────────

class TrackCaregiverScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TrackCaregiverCubit(TrackCaregiverRepo()),
      child: _TrackCaregiverBody(
        caregiverName: caregiverName,
        speciality: speciality,
        phoneNumber: phoneNumber,
        userLocation: userLocation,
      ),
    );
  }
}

// ── Private body ─────────────────────────────────────────────────────────────
// Keeps a MapController for smooth camera animation while delegating all
// network/timer logic to TrackCaregiverCubit (disposed automatically via BlocProvider).

class _TrackCaregiverBody extends StatefulWidget {
  final String caregiverName;
  final String speciality;
  final String phoneNumber;
  final String userLocation;

  const _TrackCaregiverBody({
    required this.caregiverName,
    required this.speciality,
    required this.phoneNumber,
    required this.userLocation,
  });

  @override
  State<_TrackCaregiverBody> createState() => _TrackCaregiverBodyState();
}

class _TrackCaregiverBodyState extends State<_TrackCaregiverBody> {
  static const LatLng _defaultCaregiver = LatLng(30.0444, 31.2357);
  static const LatLng _defaultUser = LatLng(30.0444, 31.2357);

  LatLng _caregiverLocation = _defaultCaregiver;
  final _mapController = MapController();

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<TrackCaregiverCubit, TrackCaregiverState>(
      listener: (context, state) {
        // Camera animation is a side-effect → handled here, not in BlocBuilder
        if (state is TrackCaregiverLoaded) {
          final newPos =
              LatLng(state.location.latitude, state.location.longitude);
          setState(() => _caregiverLocation = newPos);
          _mapController.move(newPos, 14);
        } else if (state is TrackCaregiverError && state.lastKnown != null) {
          final pos = LatLng(
              state.lastKnown!.latitude, state.lastKnown!.longitude);
          setState(() => _caregiverLocation = pos);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
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
        body: BlocBuilder<TrackCaregiverCubit, TrackCaregiverState>(
          builder: (context, state) {
            // ── Initial loading ───────────────────────────────────────────
            if (state is TrackCaregiverLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // ── Resolve last-updated timestamp ────────────────────────────
            String lastUpdated = '';
            if (state is TrackCaregiverLoaded) {
              lastUpdated = state.location.lastUpdated;
            } else if (state is TrackCaregiverError &&
                state.lastKnown != null) {
              lastUpdated = state.lastKnown!.lastUpdated;
            }

            return Column(
              children: [
                const ETABanner(eta: "—", distance: "—"),

                // Non-intrusive error ribbon — map + last known pin stay visible
                if (state is TrackCaregiverError)
                  Container(
                    color: Colors.red.shade50,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                    child: Row(
                      children: [
                        Icon(Icons.wifi_off_rounded,
                            color: Colors.red.shade700, size: 16.r),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Could not update location. Showing last known position.',
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),

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
                                color: const Color(0xFF3A8BD7),
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
                        if (lastUpdated.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Text(
                            'Last updated: ${_formatUpdated(lastUpdated)}',
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
            );
          },
        ),
      ),
    );
  }
}
