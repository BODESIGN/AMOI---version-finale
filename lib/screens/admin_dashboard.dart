import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            StaggeredGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: <Widget>[
                _buildTile(
                  color: Colors.blue,
                  icon: Icons.monetization_on,
                  title: 'Total des investissements',
                  subtitle: 'Ar 2,500,000',
                ),
                _buildTile(
                  color: Colors.orange,
                  icon: Icons.account_balance_wallet,
                  title: 'Total des retours',
                  subtitle: 'Ar 00,000',
                ),
                _buildTile(
                  color: Colors.green,
                  icon: Icons.person,
                  title: 'Utilisateurs actifs',
                  subtitle: '1,000',
                ),
                _buildTile(
                  color: Colors.pink,
                  icon: Icons.notifications,
                  title: 'Notifications',
                  subtitle: '3',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
      {required Color color,
      required IconData icon,
      required String title,
      String? subtitle}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 8),
          Icon(icon, size: 50, color: Colors.white),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle!, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
