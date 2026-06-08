import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtemam_final_project/features/recieved_offers_screen/manager/state/provider_state.dart';
import '../data/repo/Provider_repo.dart';

class ProviderCubit extends Cubit<ProviderState> {
  final ProviderRepository repo;

  ProviderCubit(this.repo) : super(ProviderInitial());

  Future<void> getProvider(String requestId) async {
    emit(ProviderLoading());

    try {
      final data = await repo.getProvider(requestId);

      emit(
        ProviderLoaded(data),
      );
    } catch (e) {
      emit(
        ProviderError(),
      );
    }
  }
}