import 'package:ehtemam_final_project/features/home_screen/data/model/bundels_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses get-all-bundles API response', () {
    final json = {
      '_id': '6a2c4aab19d98a63c2f40181',
      'client': '6a2c4aa919d98a63c2f40179',
      'price': 249,
      'bundle_name': 'Premium Bundle',
      'features': <dynamic>[],
      'isActive': true,
      'createdAt': '2026-06-12T18:06:35.012Z',
      '__v': 0,
    };

    final bundle = BundleModel.fromJson(json);

    expect(bundle.bundle_name, 'Premium Bundle');
    expect(bundle.price, 249);
    expect(bundle.discount, 0);
    expect(bundle.totalPrice, 0);
  });
}
