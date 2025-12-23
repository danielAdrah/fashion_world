import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_world/models/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('Cart Image Debug Tests', () {
    test('CartItem fromMap with empty image URL', () {
      final timestamp = Timestamp.now();

      // Test with empty image URL
      final mapWithEmptyUrl = {
        'designId': 'design_123',
        'designName': 'Summer Dress',
        'designerId': 'designer_456',
        'designerName': 'Fashion Designer',
        'price': 199.99,
        'status': 'pending',
        'timestamp': timestamp,
        'imageUrl': '',
      };

      final cartItem = CartItem.fromMap(mapWithEmptyUrl, 'test_id');

      expect(cartItem.id, 'test_id');
      expect(cartItem.designId, 'design_123');
      expect(cartItem.designName, 'Summer Dress');
      expect(cartItem.designerId, 'designer_456');
      expect(cartItem.designerName, 'Fashion Designer');
      expect(cartItem.price, 199.99);
      expect(cartItem.status, 'pending');
      expect(cartItem.timestamp, timestamp);
      expect(cartItem.imageUrl, '');
    });
  });
}
