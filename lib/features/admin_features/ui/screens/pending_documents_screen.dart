import 'package:flutter/material.dart';

class PendingDocumentsScreen extends StatelessWidget {
  const PendingDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.white,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 16,
                          color: Color(0xff64748B),
                        ),
                        SizedBox(width: 2),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: Color(0xff64748B),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xffF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.language,
                            size: 14, color: Color(0xff64748B)),
                        SizedBox(width: 4),
                        Text(
                          'العربية',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xff64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'View Documents -\nFatma Hassan',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Profile Picture',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _documentCard(
                        icon: Icons.person_outline,
                        fileName: 'profile-provider-sample.jpg',
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'National ID',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _documentCard(
                        icon: Icons.description_outlined,
                        fileName: 'national-id-fatma.pdf',
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Certificates',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _documentCard(
                        icon: Icons.description_outlined,
                        fileName: 'medical-certificate-fatma.pdf',
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text(
                            'Approve',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff34C759),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text(
                            'Reject',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _documentCard({
    required IconData icon,
    required String fileName,
  }) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 60,
            color: const Color(0xff94A3B8),
          ),
          const SizedBox(height: 12),
          Text(
            fileName,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xff64748B),
            ),
          ),
        ],
      ),
    );
  }
}