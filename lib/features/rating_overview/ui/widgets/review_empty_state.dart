import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

class ReviewEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final bool isError;
  final VoidCallback? onRetry;

  const ReviewEmptyState({
    super.key,
    required this.message,
    this.icon = Icons.rate_review_outlined,
    this.isError = false,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isError ? AppColors.lightPink : AppColors.lightPurple,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: isError ? Colors.redAccent : AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.textLight, height: 1.5)),
            if (isError && onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}