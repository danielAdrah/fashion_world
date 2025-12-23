import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id;
  final String designId;
  final String designName;
  final String designerId;
  final String designerName;
  final double price;
  final String status; // pending, confirmed, rejected
  final Timestamp timestamp;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.designId,
    required this.designName,
    required this.designerId,
    required this.designerName,
    required this.price,
    required this.status,
    required this.timestamp,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'designId': designId,
      'designName': designName,
      'designerId': designerId,
      'designerName': designerName,
      'price': price,
      'status': status,
      'timestamp': timestamp,
      'imageUrl': imageUrl,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map, String id) {
    print("Creating CartItem from map. ID: $id");
    print("Raw image URL from map: '${map['imageUrl']}'");

    // Handle potential issues with the price field
    double priceValue = 0.0;
    try {
      if (map['price'] is int) {
        priceValue = (map['price'] as int).toDouble();
      } else if (map['price'] is double) {
        priceValue = map['price'];
      } else if (map['price'] is String) {
        priceValue = double.parse(map['price']);
      }
    } catch (e) {
      print("Error parsing price: $e");
      priceValue = 0.0;
    }

    // Handle potential issues with the image URL
    String imageUrlValue = map['imageUrl'] ?? '';
    print("Initial image URL value: '$imageUrlValue'");

    // Remove any malformed query parameters
    if (imageUrlValue.contains('?_a=')) {
      try {
        final uri = Uri.parse(imageUrlValue);
        print("Parsing URI with query params: $uri");
        // Reconstruct URL without the problematic query parameter
        final cleanUri = Uri(
          scheme: uri.scheme,
          host: uri.host,
          path: uri.path,
          pathSegments: uri.pathSegments,
        );
        imageUrlValue = cleanUri.toString();
        print("Cleaned image URL: '$imageUrlValue'");
      } catch (e) {
        print("Error cleaning image URL: $e");
        // If we can't parse it, use the original
        imageUrlValue = map['imageUrl'] ?? '';
      }
    }

    print("Final image URL value: '$imageUrlValue'");

    final cartItem = CartItem(
      id: id,
      designId: map['designId'] ?? '',
      designName: map['designName'] ?? 'Unknown Design',
      designerId: map['designerId'] ?? '',
      designerName: map['designerName'] ?? 'Unknown Designer',
      price: priceValue,
      status: map['status'] ?? 'pending',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      imageUrl: imageUrlValue,
    );

    print("Created CartItem with image URL: '${cartItem.imageUrl}'");
    return cartItem;
  }
}
