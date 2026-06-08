import 'package:ehtemam_final_project/features/profile_caregiver/data/model/caregiver_model.dart';

class CaregiverRepo {
  CaregiverModel getProfile() {
    return CaregiverModel(
      name: "Fatma's Care Services",
      specialty: "Pet & Elderly Care Specialist",
      phone: "+201006570085",
      email: "fatma@careservices.com",
      location: "Elsheikh Zayed, Giza",
      rating: 4.9,
      reviews: 87,
      totalRequests: 87,
      totalEarnings: 9.9,
      completionRate: 90,
      avgResponse: "15m",
    );
  }
}