import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_world/models/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('Cart Debug Tests', () {
    test('CartItem fromMap with debugging', () {
      final timestamp = Timestamp.now();
      
      // Test with a typical Cloudinary public ID
      final mapWithPublicId = {
        'designId': 'design_123',
        'designName': 'Summer Dress',
        'designerId': 'designer_456',
        'designerName': 'Fashion Designer',
        'price': 199.99,
        'status': 'pending',
        'timestamp': timestamp,
        'imageUrl': 'sample_public_id',
      };
      
      final cartItem = CartItem.fromMap(mapWithPublicId, 'test_id');
      
      expect(cartItem.id, 'test_id');
      expect(cartItem.designId, 'design_123');
      expect(cartItem.designName, 'Summer Dress');
      expect(cartItem.designerId, 'designer_456');
      expect(cartItem.designerName, 'Fashion Designer');
      expect(cartItem.price, 199.99);
      expect(cartItem.status, 'pending');
      expect(cartItem.timestamp, timestamp);
      expect(cartItem.imageUrl, 'sample_public_id');
    });
    
    test('CartItem fromMap with malformed URL', () {
      final timestamp = Timestamp.now();
      
      // Test with malformed Cloudinary URL
      final mapWithMalformedUrl = {
        'designId': 'design_123',
        'designName': 'Summer Dress',
        'designerId': 'designer_456',
        'designerName': 'Fashion Designer',
        'price': 199.99,
        'status': 'pending',
        'timestamp': timestamp,
        'imageUrl': 'https://res.cloudinary.com/dvz3way0c/image/upload/?_a=DARAK9AAZAA0',
      };
      
      final cartItem = CartItem.fromMap(mapWithMalformedUrl, 'test_id');
      
      // The URL should be cleaned
      expect(cartItem.imageUrl, 
          'https://res.cloudinary.com/dvz3way0c/image/upload/');
    });
  });
}