import 'package:flutter/material.dart';

class PendingDocumentsDialog extends StatelessWidget {
  const PendingDocumentsDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => const PendingDocumentsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.86,
        ),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'View Documents -\nFatma Hassan',
                      style: TextStyle(
                        color: Color(0xff111827),
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.cancel_outlined,
                      size: 22,
                      color: Color(0xff475569),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const _SectionTitle(title: 'Profile Picture'),
              const SizedBox(height: 10),
              const _DocumentCard(
                icon: Icons.person_outline_rounded,
                fileName: 'profile-provider-sample.jpg',
                isProfile: true,
              ),

              const SizedBox(height: 22),

              const _SectionTitle(title: 'National ID'),
              const SizedBox(height: 10),
              const _DocumentCard(
                icon: Icons.description_outlined,
                fileName: 'national-id-fatma.pdf',
              ),

              const SizedBox(height: 22),

              const _SectionTitle(title: 'Certificates'),
              const SizedBox(height: 10),
              const _DocumentCard(
                icon: Icons.description_outlined,
                fileName: 'medical-certificate-fatma.pdf',
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Approve'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xff059669),
                    side: const BorderSide(color: Color(0xff059669)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Reject'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xff111827),
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final IconData icon;
  final String fileName;
  final bool isProfile;

  const _DocumentCard({
    required this.icon,
    required this.fileName,
    this.isProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 155,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffF1F5F9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 112,
            height: 100,
            decoration: BoxDecoration(
              color: isProfile
                  ? const Color(0xffB9DBFA)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: isProfile ? 52 : 48,
              color: isProfile
                  ? const Color(0xff2F93E6)
                  : const Color(0xff8CA0BC),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            fileName,
            style: const TextStyle(
              color: Color(0xff64748B),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}