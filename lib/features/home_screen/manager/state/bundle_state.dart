import '../../data/model/bundels_model.dart';

abstract class BundleState {}

class BundleInitial extends BundleState {}

class BundleLoading extends BundleState {}

class BundleSuccess extends BundleState {
  final List<BundleModel> bundles;

  BundleSuccess(this.bundles);
}

class BundleError extends BundleState {
  final String message;

  BundleError(this.message);
}
