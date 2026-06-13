import 'package:flutter_bloc/flutter_bloc.dart';
import 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(const UsersState());

  void getUsers() {
    // Static دلوقتي، وبعد كده هنا هتنادي API
    final users = [
      {
        'name': 'Sarah Johnson',
        'email': 'sarah.j@email.com',
        'bookings': '24 bookings',
        'joined': 'Joined Jan 2026',
        'initials': 'SJ',
        'status': 'Active',
        'premium': false,
      },
      {
        'name': 'ashraf khaled',
        'email': 'ashraf.c@email.com',
        'bookings': '12 bookings',
        'joined': 'Joined Feb 2026',
        'initials': 'MC',
        'status': 'Active',
        'premium': false,
      },
      {
        'name': 'tamer mustafa',
        'email': 'emily.d@email.com',
        'bookings': '8 bookings',
        'joined': 'Joined Dec 2025',
        'initials': 'ED',
        'status': 'Inactive',
        'premium': true,
      },
      {
        'name': 'hany wael',
        'email': 'hani.w@email.com',
        'bookings': '31 bookings',
        'joined': 'Joined Oct 2025',
        'initials': 'JW',
        'status': 'Active',
        'premium': true,
      },
      {
        'name': 'khaled sakr',
        'email': 'khaled2@email.com',
        'bookings': '5 bookings',
        'joined': 'Joined Mar 2026',
        'initials': 'LA',
        'status': 'Active',
        'premium': false,
      },
    ];

    emit(
      state.copyWith(
        allUsers: users,
        filteredUsers: users,
      ),
    );
  }

  void searchUsers(String value) {
    final query = value.trim().toLowerCase();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          searchText: value,
          filteredUsers: state.allUsers,
        ),
      );
      return;
    }

    final filtered = state.allUsers.where((user) {
      final name = user['name'].toString().toLowerCase();
      final email = user['email'].toString().toLowerCase();
      final status = user['status'].toString().toLowerCase();

      return name.contains(query) ||
          email.contains(query) ||
          status.contains(query);
    }).toList();

    emit(
      state.copyWith(
        searchText: value,
        filteredUsers: filtered,
      ),
    );
  }
}