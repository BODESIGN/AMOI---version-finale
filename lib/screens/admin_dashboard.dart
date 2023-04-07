import 'package:amoi/component/label.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    setStatutBarTheme();
    toast.init(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(children: [
              StaggeredGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: <Widget>[
                    _buildTile(
                      color: Colors.grey,
                      icon: Icons.monetization_on,
                      title: 'Total des investissements',
                      subtitle: 'Ar 2,500,000',
                      onTap: () {},
                    ),
                    _buildTile(
                      color: Colors.grey,
                      icon: Icons.person,
                      title: 'Utilisateurs actifs',
                      subtitle: '1,000',
                      onTap: () {},
                    ),
                    _buildTile(
                        color: Colors.pink,
                        icon: Icons.group,
                        title: 'Utilisateurs',
                        subtitle: 'Liste des Membres',
                        onTap: () {
                          Navigator.of(context).pushNamed('ADMIN_ALL_USER');
                        }),
                    _buildTile(
                        color: Colors.deepOrangeAccent,
                        icon: Icons.folder_shared_rounded,
                        title: 'Boites',
                        subtitle: 'Liste des Boites',
                        onTap: () {
                          Navigator.of(context).pushNamed('ADMIN_ALL_BOITE');
                        }),
                    _buildTile(
                        color: Colors.black,
                        icon: Icons.book,
                        title: 'TODO',
                        subtitle: 'Notre chose a faire',
                        onTap: () {
                          Navigator.of(context).pushNamed('ADMIN_TODO');
                        }),
                  ])
            ])));
  }

  Widget _buildTile(
      {required Color color,
      required IconData icon,
      required String title,
      required Function onTap,
      String? subtitle}) {
    return InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(icon, size: 30, color: Colors.white),
                  ),
                  LABEL(
                      text: title, color: Colors.white, isBold: true, size: 14),
                  LABEL(text: subtitle!, color: Colors.white),
                  const SizedBox(height: 10)
                ])));
  }
}
