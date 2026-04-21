import "package:flutter/material.dart";
import "package:firebase_database/firebase_database.dart";
import "package:mdp_gold/services/gold_service.dart";
import 'package:intl/intl.dart';
import "package:mdp_gold/screens/login_screen.dart";
import "package:mdp_gold/services/auth_service.dart";

class PriceListScreen extends StatefulWidget {
  const PriceListScreen({super.key});

  @override
  State<PriceListScreen> createState() => _PriceListScreenState();
}

class _PriceListScreenState extends State<PriceListScreen> {
  final GoldService _goldService = GoldService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Harga Emas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await _authService.signOut();
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _goldService.getPriceList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data?.snapshot.value;

          final Map<dynamic, dynamic> itemsMap = data as Map<dynamic, dynamic>;

          final items = itemsMap.entries.toList();

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = Map<String, dynamic>.from(items[index].value as Map);
              final String tanggal = item['tanggal'] ?? '';
              final dynamic harga = item['harga'];

              final int hargaInt = int.tryParse(harga.toString()) ?? 0;
              final String hargaFormatted = NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp',
                decimalDigits: 0,
              ).format(hargaInt);

              return ListTile(
                title: Text(
                  hargaFormatted,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text("Tanggal: $tanggal"),
              );
            },
          );
        },
      ),
    );
  }
}
