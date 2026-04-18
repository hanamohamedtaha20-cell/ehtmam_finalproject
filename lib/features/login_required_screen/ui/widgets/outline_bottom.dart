import 'package:flutter/material.dart ';

class OutlineButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const OutlineButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.blue),
              SizedBox(width: 8),
              Text(text, style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),
      ),
    );
  }
}
