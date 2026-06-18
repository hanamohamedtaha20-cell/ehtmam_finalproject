// Response shape from GET /booking/{bookingId}/location:
// {
//   "success": true,
//   "data": {
//     "bookingId":   "...",
//     "caregiverId": "...",
//     "latitude":    30.0444,
//     "longitude":   31.2357,
//     "lastUpdated": "2026-06-13T20:26:08.157Z"
//   }
// }
class CaregiverLocationModel {
  final String bookingId;
  final String caregiverId;
  final double latitude;
  final double longitude;
  final String lastUpdated;

  CaregiverLocationModel({
    required this.bookingId,
    required this.caregiverId,
    required this.latitude,
    required this.longitude,
    required this.lastUpdated,
  });

  factory CaregiverLocationModel.fromJson(Map<String, dynamic> json) {
    return CaregiverLocationModel(
      bookingId:   json['bookingId']?.toString()   ?? '',
      caregiverId: json['caregiverId']?.toString() ?? '',
      latitude:    (json['latitude']  as num?)?.toDouble() ?? 0.0,
      longitude:   (json['longitude'] as num?)?.toDouble() ?? 0.0,
      lastUpdated: json['lastUpdated']?.toString() ?? '',
    );
  }
}
