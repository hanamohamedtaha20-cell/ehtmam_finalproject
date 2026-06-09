import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../manager/provider_details_cubit.dart';
import '../../../manager/state/provider_state.dart';


class AboutProviderCard extends StatelessWidget {
  const AboutProviderCard({super.key});

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
          return Text("Error loading provider data");
        }

        /// 🔹 Success
        if (state is ProviderLoaded) {
          final p = state.provider;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "About Provider",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF374151),
                ),
              ),

              SizedBox(height: 10),

              /// 🔹 Card
              Container(
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

                    /// 🔹 Description
                    Text(
                      p.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 16),

                    /// 🔹 Stats
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFEFF2F6),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          Column(
                            children: [
                              Text(
                                p.experience,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text("Experience",
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),

                          Column(
                            children: [
                              Text(
                                p.completed.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text("Completed Services",
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    /// 🔹 Qualifications
                    Text("Qualifications",
                        style: TextStyle(fontWeight: FontWeight.bold)),

                    SizedBox(height: 8),

                    ...p.qualifications.map((q) => _item(q)),

                    SizedBox(height: 16),

                    Divider(),

                    SizedBox(height: 12),

                    /// 🔹 Contact
                    Text("Contact Information",
                        style: TextStyle(fontWeight: FontWeight.bold)),

                    SizedBox(height: 10),

                    _contactItem(Icons.phone, p.phone),
                    _contactItem(Icons.email, p.email),
                  ],
                ),
              ),
            ],
          );
        }

        return SizedBox();
      },
    );
  }

  Widget _item(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.verified_outlined, size: 16, color: Colors.blue),
          SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _contactItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}