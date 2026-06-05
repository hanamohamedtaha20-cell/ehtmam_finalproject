import 'package:ehtemam_final_project/features/requests_screen_user/data/model/request_type.dart';

class RequestModel {

  final String title;
  final String subtitle;
  final String date;
  final String amount;
  final String status;
  final String? provider;
  final RequestType type;
  final int offersCount;

  const RequestModel({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.status,
    required this.type,
    this.provider,
    this.offersCount = 0,
  });

  factory RequestModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return RequestModel(

      title:
      json['title']?.toString() ?? '',

      subtitle:
      json['subtitle']?.toString() ?? '',

      date:
      json['date']?.toString() ?? '',

      amount:
      json['amount']?.toString() ?? '',

      status:
      json['status']?.toString() ?? '',

      provider:
      json['provider']?.toString(),

      type: _mapStringToRequestType(
        json['type']?.toString(),
      ),

      offersCount:
      json['offers_count'] ?? 0,
    );
  }

  static RequestType
  _mapStringToRequestType(
      String? type,
      ) {

    switch (type?.toLowerCase()) {

      case 'pending':
        return RequestType.pending;

      case 'accepted':
        return RequestType.accepted;

      case 'completed':
        return RequestType.completed;

      case 'cancelled':
        return RequestType.cancelled;

      default:
        return RequestType.pending;
    }
  }

  Map<String, dynamic> toJson() {

    return {

      "title": title,

      "subtitle": subtitle,

      "date": date,

      "amount": amount,

      "status": status,

      "provider": provider,

      "type": type.name,

      "offers_count": offersCount,
    };
  }
}