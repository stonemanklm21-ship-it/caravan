import 'package:flutter/material.dart';

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doctor',
        ),
      ),
      body: const Center(
        child: Padding(
          padding:
              EdgeInsets.all(24),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Icon(
                Icons.medical_services,
                size: 64,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Doctor',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Player health has not been implemented yet.',
                textAlign:
                    TextAlign.center,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Future services will include treatment of injuries, illness, and other medical conditions.',
                textAlign:
                    TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}