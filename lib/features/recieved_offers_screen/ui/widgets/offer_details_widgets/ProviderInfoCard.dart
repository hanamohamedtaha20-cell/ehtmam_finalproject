import 'package:ehtemam_final_project/features/recieved_offers_screen/manager/provider_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../manager/state/provider_state.dart';


class ProviderInfoCard extends StatelessWidget {
  const ProviderInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderCubit, ProviderState>(
      builder: (context, state) {

        /// 🔹 Loading
        if (state is ProviderLoading) {
          return Center(child: CircularProgressIndicator());
        }

        /// 🔹 Error
        if (state is ProviderError) {
          return Text("Error loading data");
        }

        /// 🔹 Success
        if (state is ProviderLoaded) {
          final p = state.provider;

          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔹 Location
                _item(
                  icon: Icons.location_on_outlined,
                  title: "Governorate",
                  value: p.location.isNotEmpty ? p.location : 'Not specified',
                ),

                SizedBox(height: 16),

                /// 🔹 Availability
                _item(
                  icon: Icons.calendar_today_outlined,
                  title: "Availability",
                  value: p.availability,
                ),

                SizedBox(height: 16),

                /// 🔹 Response Time
                _item(
                  icon: Icons.access_time_outlined,
                  title: "Response Time",
                  value: p.responseTime,
                ),
              ],
            ),
          );
        }

        return SizedBox();
      },
    );
  }

  /// 🔹 نفس الفنكشن زي ما هي 👌
  Widget _item({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Color(0xFF3A8BD7)),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}