import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../manager/provider_details_cubit.dart';
import '../../manager/state/provider_state.dart';


class ProviderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderCubit, ProviderState>(
      builder: (context, state) {

        /// Loading
        if (state is ProviderLoading) {
          return Center(child: CircularProgressIndicator());
        }

        /// Error
        if (state is ProviderError) {
          return Text("Error");
        }

        /// Success
        if (state is ProviderLoaded) {
          final p = state.provider;

          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3A8BD7),
                  Color(0xFF3A8BD7),
                  Color(0xFFFFFFFF),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔹 Top Row
                Row(
                  children: [

                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFF8FB9EC),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text("👩‍🦱", style: TextStyle(fontSize: 28)),
                      ),
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// 👇 بدل static
                          Text(
                            p.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            p.service,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),

                          SizedBox(height: 8),

                          Row(
                            children: [

                              _badge(
                                icon: Icons.star,
                                text: "${p.rating} (${p.reviewsCount} Reviews)",
                                color: Colors.white,
                                bg: Colors.white.withOpacity(0.2),
                              ),

                              SizedBox(width: 6),

                              if (p.isVerified)
                                _badge(
                                  icon: Icons.verified_outlined,
                                  text: "Verified",
                                  color: Colors.white,
                                  bg: Colors.white.withOpacity(0.2),
                                ),
                            ],
                          ),

                          SizedBox(height: 6),

                          if (p.isCertified)
                            _badge(
                              icon: Icons.workspace_premium_outlined,
                              text: "Certified",
                              color: Colors.white,
                              bg: Colors.white.withOpacity(0.2),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.3),
                ),

                SizedBox(height: 12),

                /// 🔹 Bottom Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Proposed Price",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),

                        SizedBox(height: 4),

                        Row(
                          children: [
                            Text(
                              "\$${p.oldPrice}",
                              style: TextStyle(
                                color: Colors.white70,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              "\$${p.price}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Experience",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          p.experience,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return SizedBox();
      },
    );
  }

  Widget _badge({
    required IconData icon,
    required String text,
    required Color color,
    required Color bg,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}