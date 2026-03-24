import 'package:flutter/material.dart';

Widget buildMenuCard({
  required String title,
  required IconData icon,
  required Color color,
  VoidCallback? onTap,
  bool isBig = false,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6), // efek "tekan"
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: color,
        ),
        child: isBig
            ? Row(
                children: [
                  Icon(icon, color: Colors.white, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const Icon(Icons.play_arrow, color: Colors.white),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 36),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    ),
  );
}