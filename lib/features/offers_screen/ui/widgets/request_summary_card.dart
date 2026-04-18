import 'package:flutter/material.dart';

class RequestSummaryCard extends StatelessWidget {
  const RequestSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.symmetric(horizontal: 16),
      padding:  EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow:[ BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: Offset(0, 10),
          blurRadius: 10,),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3A8BD7),
            Color(0xFF5A9FE0),
            Color(0xFFD8E3E9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Pet Care",
                  style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold
                  )),
              SizedBox(height: 5,),
              Text("Care providers have responded",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12)
              ),
            ],
          ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("3 offers", style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)
                ),
              ),
            ],
      ),
    );
  }
}