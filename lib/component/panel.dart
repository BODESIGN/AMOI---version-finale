import 'package:amoi/component/appbar.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PANEL extends StatefulWidget {
  PANEL({Key? key, required this.tab}) : super(key: key);

  List<Map> tab;

  @override
  State<PANEL> createState() => _PANELState();
}

class _PANELState extends State<PANEL> {
  int current = 0;

  // ------------------------------------------------------------------
  List<Widget> _buildTab(List<Map> tab) {
    List<Widget> tabs = [];
    for (var i = 0; i < tab.length; i++) {
      tabs.add(Container(
          height: double.maxFinite,
          decoration: BoxDecoration(
              border: current == i
                  ? const Border(
                      bottom: BorderSide(color: Colors.blue, width: 2),
                    )
                  : null),
          child: InkWell(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Center(
                    child: Row(
                  children: [
                    if (current == i)
                      Icon(tab[i]['icon'], color: Colors.blue, size: 15),
                    if (current == i) const SizedBox(width: 10),
                    LABEL(
                        text: tab[i]['title'],
                        // size: 13,
                        isBold: current == i,
                        color: current == i ? Colors.blue : Colors.black),
                  ],
                )),
              ),
              onTap: () {
                setState(() => current = i);
              })));
      tabs.add(const SizedBox(width: 10));
    }
    return tabs;
  }

  // ------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = _buildTab(widget.tab);

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // HEADER
          APPBAR(user: userActif),

          // TAB
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Colors.black12, width: 1),
                )),
                height: 40,
                width: double.maxFinite,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: tabs))),
          ),

          // PANEL
          Expanded(
              flex: 1,
              child: Container(
                  color: Colors.grey[200],
                  child: widget.tab[current]['panel'])),

          // FOOTER
          BottomNavigationBar(
              currentIndex: 0,
              elevation: 10,
              onTap: (value) => setState(() {
                    // _currentIndex = value;
                    if (value == 1) {
                      Navigator.of(context).pushNamed('SECONNECT');
                    }
                  }),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard), label: 'Amoi groupe'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.power_settings_new),
                    label: 'Se déconnecter')
              ])
        ],
      ),
    );
  }
}
