import 'package:flutter/material.dart';

class DateTimeSelectionWidget extends StatelessWidget {
  const DateTimeSelectionWidget({super.key, required this.onTap, required this.title, required this.time, this.isTime = false,});
  final VoidCallback onTap;
  final String title;
  final String time;
  final bool isTime;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),

            Container(
              width: isTime? 150 : 80,
              height: 40,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade100),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                // This text will show date time as time
                child: Text(
                  time,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}