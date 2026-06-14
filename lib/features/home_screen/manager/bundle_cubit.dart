import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/bundle_repo.dart';
import 'state/bundle_state.dart';

class BundleCubit extends Cubit<BundleState> {
  final BundleRepo bundleRepo;

  BundleCubit(this.bundleRepo) : super(BundleInitial());

  Future<void> getBundles() async {
    if (isClosed) return;
    emit(BundleLoading());

    try {
      final bundles = await bundleRepo.getBundles();
      if (!isClosed) {
        emit(BundleSuccess(bundles));
      }
    } catch (e) {
      if (!isClosed) {
        emit(BundleError(e.toString()));
      }
    }
  }
}
