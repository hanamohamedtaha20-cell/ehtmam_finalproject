import 'package:ehtemam_final_project/features/profile2/data/model/profile_model.dart';

class ProfileRepo {
  UserModel getUser() {
    return UserModel(
      name: "Gena Shamel",
      email: "gena.s@email.com",
      phone: "+1 (555) 123-4567",
    );
  }
}