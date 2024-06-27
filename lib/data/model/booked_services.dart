import 'package:cloud_firestore/cloud_firestore.dart';

class BookedServicesModel {
  final num deliveryFee;
  final String discount;
  final num discountAmount;
  final String itemName;
  final String name;
  final String number;
  final List<dynamic> options; // Array field
  final String price;
  final num subtotal;
  final Timestamp timestamp;
  final num total;
  final String type;
  final String uniqueID;
  final String userId;

  BookedServicesModel({
    required this.deliveryFee,
    required this.discount,
    required this.discountAmount,
    required this.itemName,
    required this.name,
    required this.number,
    required this.options,
    required this.price,
    required this.subtotal,
    required this.timestamp,
    required this.total,
    required this.type,
    required this.uniqueID,
    required this.userId,
  });

  factory BookedServicesModel.fromMap(Map<String, dynamic> map) {
    return BookedServicesModel(
      deliveryFee: map['delivery_fee'],
      discount: map['discount'],
      discountAmount: map['discount_amount'],
      itemName: map['item_name'],
      name: map['name'],
      number: map['number'],
      options: List<dynamic>.from(map['options']),
      price: map['price'],
      subtotal: map['subtotal'],
      timestamp: map['timestamp'],
      total: map['total'],
      type: map['type'],
      uniqueID: map['uniquID'],
      userId: map['user_id'],
    );
  }
}
