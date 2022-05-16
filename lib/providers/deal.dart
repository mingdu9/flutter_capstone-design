import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;


class Deal {
  Deal({required this.date, required this.ticker,
    required this.price, required this.count});

  Deal.fromJson(Map<String, Object?> json) :
    this(
        date: json['date']! as String,
        ticker: json['ticker']! as String,
        price: json['price']! as int,
        count: json['count']! as int,
      );

  final String date;
  final String ticker;
  final int price;
  final int count;

  Map<String, Object?> toJson() {
    return {
      'date': date,
      'ticker': ticker,
      'price': price,
      'count': count,
    };
  }
}

final sellRef = firestore.collection('users').doc('${auth.currentUser!.email}').collection('sellHistory').withConverter<Deal>(
    fromFirestore: (_snapshot, _) => Deal.fromJson(_snapshot.data()!),
    toFirestore: (sell, _) => sell.toJson()
);
final soldRef = firestore.collection('users').doc('${auth.currentUser!.email}').collection('soldHistory').withConverter<Deal>(
    fromFirestore: (_snapshot, _) => Deal.fromJson(_snapshot.data()!),
    toFirestore: (sell, _) => sell.toJson()
);

