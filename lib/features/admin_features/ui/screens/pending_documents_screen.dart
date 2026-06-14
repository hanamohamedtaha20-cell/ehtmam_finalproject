import 'package:flutter/material.dart';

class PendingDocumentsScreen extends StatelessWidget {
  final Map<String, dynamic> provider;

  const PendingDocumentsScreen({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final String name = provider['name'] ?? 'Provider';

    final String? profilePicture = provider['profile_picture'];

    final List certifications = provider['certifications'] ?? [];

    final List verificationDocuments =
        provider['verifcation_documents'] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.language,
                          size: 14,
                          color: Color(0xff64748B),
                        ),
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
                          Expanded(
                            child: Text(
                              'View Documents -\n$name',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
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

                      if (profilePicture != null &&
                          profilePicture.toString().isNotEmpty)
                        _imageCard(
                          url: profilePicture,
                          fallbackIcon: Icons.person_outline,
                        )
                      else
                        _emptyDocumentCard(
                          icon: Icons.person_outline,
                          text: 'No profile picture uploaded',
                        ),

                      const SizedBox(height: 24),

                      const Text(
                        'National ID',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (verificationDocuments.isNotEmpty)
                        ...verificationDocuments.map(
                              (doc) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _imageCard(
                              url: doc.toString(),
                              fallbackIcon: Icons.description_outlined,
                            ),
                          ),
                        )
                      else
                        _emptyDocumentCard(
                          icon: Icons.description_outlined,
                          text: 'No national ID uploaded',
                        ),

                      const SizedBox(height: 24),

                      const Text(
                        'Certificates',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (certifications.isNotEmpty)
                        ...certifications.map(
                              (doc) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _imageCard(
                              url: doc.toString(),
                              fallbackIcon: Icons.workspace_premium_outlined,
                            ),
                          ),
                        )
                      else
                        _emptyDocumentCard(
                          icon: Icons.workspace_premium_outlined,
                          text: 'No certificates uploaded',
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

  Widget _imageCard({
    required String url,
    required IconData fallbackIcon,
  }) {
    return Container(
      height: 220,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _emptyDocumentCard(
            icon: fallbackIcon,
            text: 'Cannot load document',
          );
        },
      ),
    );
  }

  Widget _emptyDocumentCard({
    required IconData icon,
    required String text,
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
            size: 56,
            color: const Color(0xff94A3B8),
          ),
          const SizedBox(height: 12),
          Text(
            text,
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