// Response shape from GET /booking/{bookingId}/location:
// {
//   "status": "success",
//   "data": {
//     "latitude":  29.123456,
//     "longitude": 31.654321,
//     "updatedAt": "2026-06-18T17:05:52.428Z"
//   }
// }
class CaregiverLocationModel {
  final String bookingId;
  final String caregiverId;
  final double latitude;
  final double longitude;
  final String lastUpdated;

  CaregiverLocationModel({
    this.bookingId = '',
    this.caregiverId = '',
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
      // backend returns 'updatedAt'; old shape had 'lastUpdated'
      lastUpdated: json['updatedAt']?.toString() ??
                   json['lastUpdated']?.toString() ?? '',
    );
  }
}
