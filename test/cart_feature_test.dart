import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_world/models/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('Cart Feature Tests', () {
    test('CartItem model creation', () {
      final timestamp = Timestamp.now();

      final cartItem = CartItem(
        id: 'test_id',
        designId: 'design_123',
        designName: 'Summer Dress',
        designerId: 'designer_456',
        designerName: 'Fashion Designer',
        price: 199.99,
        status: 'pending',
        timestamp: timestamp,
        imageUrl: 'https://example.com/image.jpg',
      );

      expect(cartItem.id, 'test_id');
      expect(cartItem.designId, 'design_123');
      expect(cartItem.designName, 'Summer Dress');
      expect(cartItem.designerId, 'designer_456');
      expect(cartItem.designerName, 'Fashion Designer');
      expect(cartItem.price, 199.99);
      expect(cartItem.status, 'pending');
      expect(cartItem.timestamp, timestamp);
      expect(cartItem.imageUrl, 'https://example.com/image.jpg');
    });

    test('CartItem toMap conversion', () {
      final timestamp = Timestamp.now();

      final cartItem = CartItem(
        id: 'test_id',
        designId: 'design_123',
        designName: 'Summer Dress',
        designerId: 'designer_456',
        designerName: 'Fashion Designer',
        price: 199.99,
        status: 'pending',
        timestamp: timestamp,
        imageUrl: 'https://example.com/image.jpg',
      );

      final map = cartItem.toMap();

      expect(map['designId'], 'design_123');
      expect(map['designName'], 'Summer Dress');
      expect(map['designerId'], 'designer_456');
      expect(map['designerName'], 'Fashion Designer');
      expect(map['price'], 199.99);
      expect(map['status'], 'pending');
      expect(map['timestamp'], timestamp);
      expect(map['imageUrl'], 'https://example.com/image.jpg');
    });
  });
}
