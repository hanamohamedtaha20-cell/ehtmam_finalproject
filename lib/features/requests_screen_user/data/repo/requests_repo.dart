import '../model/model.dart';
import '../model/request_type.dart';


class RequestsRepo {

  Future<List<RequestModel>>
  getRequests() async {

    await Future.delayed(
      const Duration(seconds: 1),
    );

    return [

      RequestModel(
        title: "Pet Care",
        subtitle: "Dog • 5 days",
        date: "March 15, 2026",
        amount: "2500",
        status: "Pending",
        type: RequestType.pending,
      ),
      RequestModel(
        title: "Elderly Care",
        subtitle: "3 days",
        date: "March 20, 2026",
        provider: "Fatma Medical Care",
        amount: "450",
        status: "Accepted",
        type: RequestType.accepted,
        offersCount: 3,
      ),

      RequestModel(
        title: "Child Care",
        subtitle: "2 days",
        date: "March 10, 2026",
        provider: "Sarah Child Services",
        amount: "2000",
        status: "Completed",
        type: RequestType.completed,
      ),

      RequestModel(
        title: "Pet Care",
        subtitle: "Cat • 7 days",
        date: "March 5, 2026",
        amount: "550",
        status: "Cancelled",
        type: RequestType.cancelled,
      ),
    ];
  }
}