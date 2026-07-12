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
import 'package:easy_localization/easy_localization.dart';

class TrackCaregiverScreen extends StatelessWidget {
  final String caregiverName;
  final String speciality;
  final String phoneNumber;
  final String userLocation;
  final String bookingId;
  final String caregiverPicture;
  final double caregiverRating;
  final int caregiverReviewCount;

  const TrackCaregiverScreen({
    super.key,
    required this.caregiverName,
    required this.speciality,
    required this.phoneNumber,
    required this.userLocation,
    required this.bookingId,
    this.caregiverPicture = '',
    this.caregiverRating = 0,
    this.caregiverReviewCount = 0,
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
        bookingId: bookingId,
        caregiverPicture: caregiverPicture,
        caregiverRating: caregiverRating,
        caregiverReviewCount: caregiverReviewCount,
      ),
    );
  }
}

class _TrackCaregiverBody extends StatefulWidget {
  final String caregiverName;
  final String speciality;
  final String phoneNumber;
  final String userLocation;
  final String bookingId;
  final String caregiverPicture;
  final double caregiverRating;
  final int caregiverReviewCount;

  const _TrackCaregiverBody({
    required this.caregiverName,
    required this.speciality,
    required this.phoneNumber,
    required this.userLocation,
    required this.bookingId,
    this.caregiverPicture = '',
    this.caregiverRating = 0,
    this.caregiverReviewCount = 0,
  });

  @override
  State<_TrackCaregiverBody> createState() => _TrackCaregiverBodyState();
}

class _TrackCaregiverBodyState extends State<_TrackCaregiverBody> {
  static const LatLng _defaultLocation = LatLng(30.0444, 31.2357);

  LatLng _caregiverLocation = _defaultLocation;
  final _mapController = MapController();
  bool _trackingStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_trackingStarted) {
      _trackingStarted = true;
      context.read<TrackCaregiverCubit>().startTracking(widget.bookingId);
    }
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<TrackCaregiverCubit, TrackCaregiverState>(
      listener: (context, state) {
        if (state is TrackCaregiverLoaded) {
          final newPos =
              LatLng(state.location.latitude, state.location.longitude);
          setState(() => _caregiverLocation = newPos);
          _mapController.move(newPos, 14);
        } else if (state is TrackCaregiverError && state.lastKnown != null) {
          setState(() => _caregiverLocation = LatLng(
              state.lastKnown!.latitude, state.lastKnown!.longitude));
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
          title: Text('track_caregiver'.tr(),
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
            if (state is TrackCaregiverLoading) {
              return const Center(child: CircularProgressIndicator());
            }

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
                              point: _defaultLocation,
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
                          rating: widget.caregiverRating > 0
                              ? widget.caregiverRating.toStringAsFixed(1)
                              : "0",
                          reviewCount: widget.caregiverReviewCount.toString(),
                          status: "On the way",
                          statusSubtitle:
                              "Caregiver is heading to your location",
                          phoneNumber: widget.phoneNumber.isEmpty
                              ? "-"
                              : widget.phoneNumber,
                          caregiverPicture: widget.caregiverPicture,
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
