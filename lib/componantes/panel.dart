
import 'package:flutter/material.dart';
import 'package:side_navigation/side_navigation.dart';

class PANEL extends StatefulWidget {
  PANEL(
      {super.key,
      required this.tabs,
      required this.panels,
      required this.onTabChange});

  bool isExpanded = false;

  List<Widget> panels;
  List<Map<String, IconData>> tabs;
  Function onTabChange;

  @override
  State<PANEL> createState() => _PANELState();
}

class _PANELState extends State<PANEL> {
  late List<Widget> panels;
  List<SideNavigationBarItem> tabs = [];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    setState(() {
      panels = widget.panels;
      tabs = [];
      for (var element in widget.tabs) {
        element.forEach((k, v) {
          tabs.add(SideNavigationBarItem(icon: v, label: k.toString()));
        });
      }
    });
    return Row(children: [
      SideNavigationBar(
          selectedIndex: selectedIndex,
          initiallyExpanded: false,
          items: tabs,
          onTap: (index) {
            setState(() => selectedIndex = index);
            widget.onTabChange(index);
          },
          toggler: SideBarToggler(
            expandIcon: Icons.menu,
            shrinkIcon: Icons.keyboard_arrow_left_sharp,
            onToggle: () =>
                setState(() => widget.isExpanded = !widget.isExpanded),
          ),
          theme: SideNavigationBarTheme(
            backgroundColor: Colors.black,
            itemTheme: SideNavigationBarItemTheme(
                unselectedItemColor: Colors.white38,
                selectedItemColor: Colors.blue,
                iconSize: 20,
                labelTextStyle:
                    const TextStyle(fontSize: 12, color: Colors.blue)),
            togglerTheme: const SideNavigationBarTogglerTheme(
                expandIconColor: Colors.blue, shrinkIconColor: Colors.white),
            dividerTheme: SideNavigationBarDividerTheme.standard(),
          )),
      Expanded(child: panels.elementAt(selectedIndex))
    ]);
  }
}
