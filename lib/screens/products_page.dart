import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_form_sheet.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});
  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _svc = ProductService();
  String _search = '';
  final _minCtrl = TextEditingController();
  final _maxCtrl = TextEditingController();
  double? _minPrice, _maxPrice;

  @override
  void dispose() {
    _minCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _stream() =>
      _svc.stream(search: _search, minPrice: _minPrice, maxPrice: _maxPrice);

  void _openForm({Product? p}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ProductFormSheet(
        initialName: p?.name,
        initialPrice: p?.price,
        onSave: (name, price) async {
          if (p == null) {
            await _svc.add(name, price);
          } else {
            await _svc.update(p.id, name, price);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRUD operations')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search by name',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => _search = v.trim()),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _minCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Min price',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _maxCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Max price',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _minPrice = _minCtrl.text.isEmpty
                              ? null
                              : double.tryParse(_minCtrl.text);
                          _maxPrice = _maxCtrl.text.isEmpty
                              ? null
                              : double.tryParse(_maxCtrl.text);
                        });
                      },
                      child: const Text('Filter'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        _minCtrl.clear();
                        _maxCtrl.clear();
                        setState(() {
                          _minPrice = null;
                          _maxPrice = null;
                        });
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _stream(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snap.hasData || snap.data!.docs.isEmpty) {
                  return const Center(child: Text('No products found'));
                }

                final docs =
                    snap.data!.docs.map((d) => Product.fromDoc(d)).where((p) {
                  if (_search.isEmpty ||
                      (_minPrice == null && _maxPrice == null)) return true;
                  return p.name.startsWith(_search);
                }).toList();

                if (docs.isEmpty)
                  return const Center(child: Text('No products found'));

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final p = docs[i];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(p.name),
                        subtitle: Text(p.price.toString()),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _openForm(p: p)),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await _svc.delete(p.id);
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'You have successfully deleted a product')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
