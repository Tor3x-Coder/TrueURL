import 'package:flutter/material.dart';
import 'package:trueurl/models/brand.dart';

class BrandBookScreen extends StatelessWidget {
  const BrandBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brands = BrandBook.brands;

    // Group by category
    final Map<String, List<Brand>> grouped = {};
    for (final brand in brands) {
      grouped.putIfAbsent(brand.category, () => []).add(brand);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Official Brand Book'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0066CC),
                  ),
                ),
              ),
              ...entry.value.map((brand) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.verified, color: Colors.green),
                      title: Text(brand.name),
                      subtitle: Text(brand.domains.join(', ')),
                      trailing: brand.warning != null
                          ? const Icon(Icons.info_outline, color: Colors.orange)
                          : null,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(brand.name),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Official domains:'),
                                const SizedBox(height: 8),
                                ...brand.domains.map((d) => Text('• $d')),
                                if (brand.warning != null) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    color: Colors.orange.shade50,
                                    child: Text(brand.warning!),
                                  ),
                                ],
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )),
              const SizedBox(height: 8),
            ],
          );
        }).toList(),
      ),
    );
  }
}