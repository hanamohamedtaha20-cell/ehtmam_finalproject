import 'package:ehtemam_final_project/features/offer_details_screen/manager/state/provider_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/Provider_repo.dart';


class ProviderCubit extends Cubit<ProviderState> {
  final ProviderRepository repo;

  ProviderCubit(this.repo) : super(ProviderInitial());

  void getProvider() async {
    emit(ProviderLoading());

    try {
      final data = await repo.getProvider();
      emit(ProviderLoaded(data));
    } catch (e) {
      emit(ProviderError());
    }
  }
}