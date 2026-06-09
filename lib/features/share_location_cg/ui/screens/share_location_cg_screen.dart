import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/location_status_banner.dart';
import '../widgets/client_info_card.dart';
import '../widgets/location_details_cg.dart';

class ShareLocationCgScreen extends StatefulWidget {
  const ShareLocationCgScreen({super.key});

  static const LatLng _clientLocation    = LatLng(30.0444, 31.2357);
  static const LatLng _caregiverLocation = LatLng(30.0500, 31.2400);

  @override
  State<ShareLocationCgScreen> createState() => _ShareLocationCgScreenState();
}

class _ShareLocationCgScreenState extends State<ShareLocationCgScreen> {
  String _clientName = '';
  String _clientAddress = '';
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _clientName = prefs.getString('user_name') ?? 'Client';
      _clientAddress = prefs.getString('user_government') ?? 'Cairo, Egypt';
    });
  }

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
        title: const Text(
          "Share Location",
          style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          LocationStatusBanner(eta: "15 min", distance: "2.3 km", isSharing: _isSharing),
          SizedBox(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: ShareLocationCgScreen._caregiverLocation,
                  initialZoom: 14,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.ehtemam',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: ShareLocationCgScreen._caregiverLocation,
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.location_pin, color: Colors.green, size: 40),
                      ),
                      Marker(
                        point: ShareLocationCgScreen._clientLocation,
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.person_pin_circle, color: Color(0xFF3A8BD7), size: 40),
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
                  ClientInfoCard(
                    name: _clientName,
                    serviceType: "Elderly Care Service",
                    status: "Waiting for your arrival",
                    statusSubtitle: "Client is waiting for you",
                    isSharing: _isSharing,
                    onShareToggle: () => setState(() => _isSharing = !_isSharing),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Location Details",
                    style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 12),
                  LocationDetailsCg(
                    clientLocation: _clientAddress,
                    caregiverLocation: "Your Current Location",
                    distance: "2.3 km",
                    eta: "15 min",
                  ),
                  const SizedBox(height: 12),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color.fromARGB(55, 0, 0, 0), blurRadius: 6, offset: Offset(0, 2)),
                        ],
                      ),
                    child:  Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.circle , color: Colors.blue, size: 10,),
                            SizedBox(width: 2,),
                            Text(
                              "Privacy Notice",
                              style: TextStyle(fontFamily: "Arimo", fontSize: 13, color: Colors.blue[900]),
                            ),
                          ],
                        ),
                        Text('Your location will only be shared with the client during active service.You can stop sharing at any time.',
                        style: TextStyle(fontFamily: "Arimo", fontSize: 13, color: Colors.blue[900]),
                        )
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