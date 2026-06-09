import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/model/hc_request_model.dart';
import 'hc_state.dart';

class HcHomeCubit extends Cubit<HcHomeState> {
  HcHomeCubit() : super(HcHomeInitial()) {
    getHomeData();
  }

  bool isAvailable = true;

  void getHomeData() {
    emit(
      HcHomeLoaded(
        isAvailable: isAvailable,
        requests: [
          HcRequestModel(
            title: 'Pet Care',
            price: '550',
            description: 'Dog - Golden Retriever, 5 days',
            startDate: 'March 15, 2026',
            location: '123 Main Street, Cairo',
            specialRequirement: 'Needs daily walks and special diet',
          ),
          HcRequestModel(
            title: 'Elderly Care',
            price: '4500',
            description: 'Post-surgery care, 3 days',
            startDate: 'March 20, 2026',
            location: '456 Salah Salem, Giza',
            specialRequirement: 'Medication assistance required',
          ),
        ],
      ),
    );
  }

  void changeAvailability(bool value) {
    isAvailable = value;

    final List<HcRequestModel> currentRequests =
    state is HcHomeLoaded
        ? (state as HcHomeLoaded).requests
        : <HcRequestModel>[];

    emit(
      HcHomeLoaded(
        isAvailable: isAvailable,
        requests: currentRequests,
      ),
    );
  }
}