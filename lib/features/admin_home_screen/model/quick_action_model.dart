import 'package:flutter/material.dart';

class QuickActionModel {
  final String title;
  final IconData icon;
  final int? badgeCount;

  QuickActionModel({
    required this.title,
    required this.icon,
    this.badgeCount,
  });

  factory QuickActionModel.fromJson(Map<String, dynamic> json) {
    return QuickActionModel(
      title: json['title']?.toString() ?? '',
      icon: Icons.dashboard,
      badgeCount: json['badge_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'badge_count': badgeCount,
    };
  }
}