import 'package:flutter/material.dart';

class AdProviderHeader extends StatelessWidget {
  final Function(String)? onSearch;

  const AdProviderHeader({
    super.key,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Providers',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Color(0xff1F2937),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 56,
            child: TextField(
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: 'Search Providers...',
                hintStyle: const TextStyle(
                  color: Color(0xff9CA3AF),
                  fontSize: 15,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 28,
                  color: Color(0xff6B7280),
                ),
                filled: true,
                fillColor: const Color(0xffF3F4F6),
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xffE5E7EB),
          ),
        ],
      ),
    );
  }
}