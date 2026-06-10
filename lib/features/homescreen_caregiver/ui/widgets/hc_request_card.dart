import 'package:ehtemam_final_project/features/request_screen_caregiver/data/model/care_request.dart';
import 'package:flutter/material.dart';

class HcRequestCard extends StatelessWidget {
  final CareRequestModel request;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onViewDetails;

  const HcRequestCard({
    super.key,
    required this.request,
    this.onAccept,
    this.onDecline,
    this.onViewDetails,
  });

  String get _subtitle {
    if (request.duration.isNotEmpty) {
      return request.duration;
    }
    return request.serviceName;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final s = (width / 390).clamp(0.85, 1.15);

    return Container(
      margin: EdgeInsets.fromLTRB(16 * s, 0, 16 * s, 14 * s),
      padding: EdgeInsets.all(16 * s),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * s),
        border: Border.all(color: const Color(0xFFE4E7EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  request.serviceName,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18 * s,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0B2B5A),
                  ),
                ),
              ),
              Text(
                request.price,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18 * s,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF3A8BD7),
                ),
              ),
            ],
          ),
          SizedBox(height: 6 * s),
          Text(
            _subtitle,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13 * s,
              color: const Color(0xFF667085),
            ),
          ),
          if (request.clientName.isNotEmpty) ...[
            SizedBox(height: 2 * s),
            Text(
              'Requested by: ${request.clientName}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12 * s,
                color: const Color(0xFF98A2B3),
              ),
            ),
          ],
          SizedBox(height: 12 * s),
          if (request.date.isNotEmpty)
            _InfoRow(
              scale: s,
              icon: Icons.calendar_today_outlined,
              text: 'Start: ${request.date}',
            ),
          if (request.location.isNotEmpty)
            _InfoRow(
              scale: s,
              icon: Icons.location_on_outlined,
              text: request.location,
            ),
          if (request.notes.isNotEmpty) ...[
            SizedBox(height: 10 * s),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12 * s),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FF),
                borderRadius: BorderRadius.circular(12 * s),
              ),
              child: Text(
                'Special Requirements: ${request.notes}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12 * s,
                  color: const Color(0xFF3A8BD7),
                  height: 1.4,
                ),
              ),
            ),
          ],
          SizedBox(height: 16 * s),
          Row(
            children: [
              Expanded(
                child: _AcceptButton(
                  scale: s,
                  onTap: onAccept,
                ),
              ),
              SizedBox(width: 12 * s),
              Expanded(
                child: _DeclineButton(
                  scale: s,
                  onTap: onDecline,
                ),
              ),
            ],
          ),
          SizedBox(height: 14 * s),
          Center(
            child: InkWell(
              onTap: onViewDetails,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Full Details',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14 * s,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3A8BD7),
                    ),
                  ),
                  SizedBox(width: 4 * s),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16 * s,
                    color: const Color(0xFF3A8BD7),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final double scale;
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.scale,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8 * scale),
      child: Row(
        children: [
          Icon(icon, size: 16 * scale, color: const Color(0xFF98A2B3)),
          SizedBox(width: 8 * scale),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13 * scale,
                color: const Color(0xFF667085),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AcceptButton extends StatelessWidget {
  final double scale;
  final VoidCallback? onTap;

  const _AcceptButton({
    required this.scale,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14 * scale),
        child: Ink(
          height: 44 * scale,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3A8BD7), Color(0xFF6CB4F5)],
            ),
            borderRadius: BorderRadius.circular(14 * scale),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_rounded, color: Colors.white, size: 18 * scale),
              SizedBox(width: 6 * scale),
              Text(
                'Accept',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14 * scale,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeclineButton extends StatelessWidget {
  final double scale;
  final VoidCallback? onTap;

  const _DeclineButton({
    required this.scale,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14 * scale),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14 * scale),
        child: Container(
          height: 44 * scale,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14 * scale),
            border: Border.all(color: const Color(0xFFD0D5DD)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.close_rounded, color: const Color(0xFF667085), size: 18 * scale),
              SizedBox(width: 6 * scale),
              Text(
                'Decline',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14 * scale,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF667085),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
