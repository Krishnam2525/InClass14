import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final _col = FirebaseFirestore.instance.collection('products');

  Stream<QuerySnapshot<Map<String, dynamic>>> stream({
    String search = '',
    double? minPrice,
    double? maxPrice,
  }) {
    Query<Map<String, dynamic>> q = _col.withConverter<Map<String, dynamic>>(
      fromFirestore: (s, _) => s.data() ?? {},
      toFirestore: (d, _) => d,
    );

    final hasPrice = minPrice != null || maxPrice != null;
    if (hasPrice) {
      q = q.orderBy('price');
      if (minPrice != null)
        q = q.where('price', isGreaterThanOrEqualTo: minPrice);
      if (maxPrice != null) q = q.where('price', isLessThanOrEqualTo: maxPrice);
      return q.snapshots();
    }

    if (search.isNotEmpty) {
      q = q.orderBy('name').startAt([search]).endAt(['$search\uf8ff']);
    } else {
      q = q.orderBy('name');
    }
    return q.snapshots();
  }

  Future<void> add(String name, double price) async {
    await _col.add({'name': name, 'price': price});
  }

  Future<void> update(String id, String name, double price) async {
    await _col.doc(id).update({'name': name, 'price': price});
  }

  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }
}
