import '../model/provider_data.dart';


class ProviderRepository {
  Future<ProviderModel> getProvider() async {

    await Future.delayed(Duration(seconds: 1));

    return ProviderModel(
      description: "With over 5 years of professional experience...",
      experience: "5+ years",
      completed: 340,
      qualifications: [
        "Certified Pet Care Specialist",
        "Pet First Aid Certified",
        "Animal Behavior Training",
        "Veterinary Assistant Background",
      ],
      phone: "+20115570085",
      email: "sarah@pawsandclaws.com",
      location: '',
      availability: '',
      responseTime: '',
      name: "Sarah Adam",
      service: "Paws & Claws Care",
      rating: 4.9,
      reviewsCount: 127,
      isVerified: true,
      isCertified: true,
      price: 280.0,
      oldPrice: 350.0,
      specialization: "Pet Grooming & Training",
      notes: "I'd love to care for your pet...",
      bestValue: true,
    );
  }
}