import 'package:ehtemam_final_project/features/booking_user/ui/screens/booking_screen_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/eta_banner.dart';
import '../widgets/caregiver_info_card.dart';
import '../widgets/location_details.dart';
class TrackCaregiverScreen extends StatelessWidget {
  final String caregiverName;
  final String speciality;
  final String phoneNumber;
  final String userLocation;

  const TrackCaregiverScreen({
    super.key,
    required this.caregiverName,
    required this.speciality,
    required this.phoneNumber,
    required this.userLocation,
  });

  static const LatLng _userLocation      = LatLng(30.0444, 31.2357);
  static const LatLng _caregiverLocation = LatLng(30.0500, 31.2400);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () =>Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BookingScreenUser(),
        ),
          )),
        title: const Text(
          "Track Caregiver",
          style: TextStyle(
            fontFamily: "Arimo",
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
       
      ),
      body: Column(
        children: [
          const ETABanner(eta: "14 min", distance: "2.0 km"),
          SizedBox(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FlutterMap(
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
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.green,
                          size: 40,
                        ),
                      ),
                      Marker(
                        point: _userLocation,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.person_pin_circle,
                          color: Color(0xFF3A8BD7),
                          size: 40,
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CaregiverInfoCard(
                    name:           caregiverName.isEmpty ? "Caregiver" : caregiverName,
                    speciality:     speciality.isEmpty ? "Care Service" : speciality,
                    rating:         "4.8",
                    reviewCount:    "99",
                    status:         "On the way",
                    statusSubtitle: "Caregiver is heading to your location",
                    phoneNumber:    phoneNumber.isEmpty ? "-" : phoneNumber,
                  ),
                  const SizedBox(height: 12),
                  LocationDetails(
                    userLocation:      userLocation.isEmpty ? "Your Location" : userLocation,
                    caregiverLocation: "456 Oak Avenue",
                    distance:          "2.0 km",
                    eta:               "14 min",
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