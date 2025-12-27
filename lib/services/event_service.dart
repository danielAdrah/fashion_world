import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/fashion_event.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new fashion event
  Future<String> addEvent(FashionEvent event) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('fashion_events').add(event.toMap());
      return docRef.id;
    } catch (e) {
      print("Error adding event: $e");
      rethrow;
    }
  }

  // Fetch all fashion events
  Stream<List<FashionEvent>> getAllEvents() {
    return _firestore
        .collection('fashion_events')
        .orderBy('startDate', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FashionEvent.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Fetch featured fashion events
  Stream<List<FashionEvent>> getFeaturedEvents() {
    return _firestore
        .collection('fashion_events')
        .where('isFeatured', isEqualTo: true)
        .orderBy('startDate', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FashionEvent.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Fetch events by type
  Stream<List<FashionEvent>> getEventsByType(String eventType) {
    return _firestore
        .collection('fashion_events')
        .where('eventType', isEqualTo: eventType)
        .orderBy('startDate', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FashionEvent.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Fetch events by date range
  Stream<List<FashionEvent>> getEventsByDateRange(
      DateTime start, DateTime end) {
    return _firestore
        .collection('fashion_events')
        .where('startDate', isGreaterThanOrEqualTo: start)
        .where('endDate', isLessThanOrEqualTo: end)
        .orderBy('startDate', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FashionEvent.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Fetch events by location
  Stream<List<FashionEvent>> getEventsByLocation(String location) {
    return _firestore
        .collection('fashion_events')
        .where('location', isEqualTo: location)
        .orderBy('startDate', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FashionEvent.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Fetch events for a specific designer
  Stream<List<FashionEvent>> getEventsForDesigner(String designerId) {
    return _firestore
        .collection('fashion_events')
        .where('designers', arrayContains: designerId)
        .orderBy('startDate', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FashionEvent.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Update an event
  Future<void> updateEvent(String eventId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('fashion_events').doc(eventId).update(data);
    } catch (e) {
      print("Error updating event: $e");
      rethrow;
    }
  }

  // Delete an event
  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('fashion_events').doc(eventId).delete();
    } catch (e) {
      print("Error deleting event: $e");
      rethrow;
    }
  }

  // Get event by ID
  Future<FashionEvent?> getEventById(String eventId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('fashion_events').doc(eventId).get();
      if (doc.exists) {
        return FashionEvent.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print("Error getting event by ID: $e");
      rethrow;
    }
  }
}
