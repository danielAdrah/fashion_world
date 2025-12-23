import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_world/models/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('Cart Fix Tests', () {
    test('CartItem fromMap handles invalid price gracefully', () {
      final timestamp = Timestamp.now();

      // Test with string price
      final mapWithStringPrice = {
        'designId': 'design_123',
        'designName': 'Summer Dress',
        'designerId': 'designer_456',
        'designerName': 'Fashion Designer',
        'price': '199.99',
        'status': 'pending',
        'timestamp': timestamp,
        'imageUrl': 'https://example.com/image.jpg',
      };

      final cartItem1 = CartItem.fromMap(mapWithStringPrice, 'test_id');
      expect(cartItem1.price, 199.99);

      // Test with integer price
      final mapWithIntPrice = {
        'designId': 'design_123',
        'designName': 'Summer Dress',
        'designerId': 'designer_456',
        'designerName': 'Fashion Designer',
        'price': 200,
        'status': 'pending',
        'timestamp': timestamp,
        'imageUrl': 'https://example.com/image.jpg',
      };

      final cartItem2 = CartItem.fromMap(mapWithIntPrice, 'test_id');
      expect(cartItem2.price, 200.0);

      // Test with invalid price (should default to 0.0)
      final mapWithInvalidPrice = {
        'designId': 'design_123',
        'designName': 'Summer Dress',
        'designerId': 'designer_456',
        'designerName': 'Fashion Designer',
        'price': 'invalid_price',
        'status': 'pending',
        'timestamp': timestamp,
        'imageUrl': 'https://example.com/image.jpg',
      };

      final cartItem3 = CartItem.fromMap(mapWithInvalidPrice, 'test_id');
      expect(cartItem3.price, 0.0);
    });

    test('CartItem fromMap handles missing fields gracefully', () {
      final mapWithMissingFields = {
        'designId': 'design_123',
        // Missing other fields
      };

      final cartItem = CartItem.fromMap(mapWithMissingFields, 'test_id');

      expect(cartItem.designId, 'design_123');
      expect(cartItem.designName, 'Unknown Design');
      expect(cartItem.designerId, '');
      expect(cartItem.designerName, 'Unknown Designer');
      expect(cartItem.price, 0.0);
      expect(cartItem.status, 'pending');
    });
  });
}
