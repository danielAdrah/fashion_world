import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/fashion_event.dart';

class SampleEvents {
  static Future<void> addSampleEvents() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Sample fashion events
    List<FashionEvent> sampleEvents = [
      FashionEvent(
        id: '',
        title: 'New York Fashion Week',
        description:
            'The premier fashion event showcasing the latest collections from top designers.',
        location: 'New York, USA',
        startDate: DateTime(2024, 9, 6),
        endDate: DateTime(2024, 9, 10),
        eventType: 'fashion_week',
        imageUrl: 'fashion_week_ny',
        organizer: 'Fashion Institute of Technology',
        website: 'https://www.nyfw.com',
        designers: [],
        timestamp: Timestamp.now(),
        isFeatured: true,
      ),
      FashionEvent(
        id: '',
        title: 'Paris Haute Couture Week',
        description:
            'Exclusive showcase of haute couture from the world\'s most prestigious fashion houses.',
        location: 'Paris, France',
        startDate: DateTime(2024, 7, 1),
        endDate: DateTime(2024, 7, 4),
        eventType: 'fashion_week',
        imageUrl: 'fashion_week_paris',
        organizer: 'Fédération de la Haute Couture',
        website: 'https://www.pariscoutureweek.com',
        designers: [],
        timestamp: Timestamp.now(),
        isFeatured: true,
      ),
      FashionEvent(
        id: '',
        title: 'Virtual Digital Fashion Show',
        description:
            'Experience the future of fashion with our virtual reality fashion show featuring digital clothing.',
        location: 'Online',
        startDate: DateTime(2024, 8, 15),
        endDate: DateTime(2024, 8, 15),
        eventType: 'virtual_show',
        imageUrl: 'virtual_fashion_show',
        organizer: 'Digital Fashion Institute',
        website: 'https://www.virtualfashionshow.com',
        designers: [],
        timestamp: Timestamp.now(),
        isFeatured: false,
      ),
      FashionEvent(
        id: '',
        title: 'Local Designer Showcase',
        description:
            'Support local talent as emerging designers present their latest collections.',
        location: 'Downtown Fashion District',
        startDate: DateTime(2024, 8, 20),
        endDate: DateTime(2024, 8, 22),
        eventType: 'designer_showcase',
        imageUrl: 'local_designer_showcase',
        organizer: 'Fashion World Platform',
        website: 'https://www.fashionworld.com',
        designers: [],
        timestamp: Timestamp.now(),
        isFeatured: false,
      ),
    ];

    // Add each event to Firestore
    for (FashionEvent event in sampleEvents) {
      try {
        await firestore.collection('fashion_events').add(event.toMap());
        print('Added event: ${event.title}');
      } catch (e) {
        print('Error adding event: $e');
      }
    }
  }
}
