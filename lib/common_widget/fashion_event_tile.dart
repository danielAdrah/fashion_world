// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:flutter/material.dart';
import '../models/fashion_event.dart';
import '../theme.dart';

class FashionEventTile extends StatelessWidget {
  const FashionEventTile({
    super.key,
    required this.event,
  });

  final FashionEvent event;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    // Format dates
    String formattedStartDate = _formatDate(event.startDate);
    String formattedEndDate = _formatDate(event.endDate);

    return FadeInUp(
      child: Container(
        width: width * (width > 600 ? 0.7 : 0.9),
        margin: EdgeInsets.symmetric(
          horizontal: width * (1 - (width > 600 ? 0.7 : 0.9)) / 2,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event image
            if (event.imageUrl.isNotEmpty)
              Container(
                width: double.infinity,
                height: width > 600 ? 200 : 150,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: CldImageWidget(
                    publicId: event.imageUrl,
                    width: double.infinity,
                    height: width > 600 ? 200 : 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            // Event details
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event title
                  Text(
                    event.title,
                    style: TextStyle(
                      color: TColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width > 600 ? 18 : 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Event type and organizer
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: TColor.primary.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getEventTypeLabel(event.eventType),
                          style: TextStyle(
                            color: TColor.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'by ${event.organizer}',
                          style: TextStyle(
                            color: TColor.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Date and location
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: TColor.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '$formattedStartDate - $formattedEndDate',
                          style: TextStyle(
                            color: TColor.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: TColor.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(
                            color: TColor.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Description
                  const SizedBox(height: 10),
                  Text(
                    event.description,
                    style: TextStyle(
                      color: TColor.white.withOpacity(0.9),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  // Action buttons
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Open event website
                            _launchURL(event.website);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColor.primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Learn More',
                            style: TextStyle(
                              color: TColor.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (event.designers.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${event.designers.length} Designer${event.designers.length != 1 ? 's' : ''}',
                            style: TextStyle(
                              color: TColor.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  String _getEventTypeLabel(String eventType) {
    switch (eventType) {
      case 'fashion_week':
        return 'Fashion Week';
      case 'designer_showcase':
        return 'Designer Showcase';
      case 'virtual_show':
        return 'Virtual Show';
      case 'retail_event':
        return 'Retail Event';
      default:
        return eventType.replaceAll('_', ' ').toUpperCase();
    }
  }

  void _launchURL(String url) {
    // In a real implementation, you would use url_launcher package
    // For now, we'll just print the URL
    print('Opening URL: $url');
  }
}
