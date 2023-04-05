import 'package:flutter/material.dart';
import 'package:side_navigation/side_navigation.dart';

// ignore: must_be_immutable
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




// ================================



// class PANEL extends StatefulWidget {
//   PANEL(
//       {super.key,
//       required this.tabs,
//       required this.panels,
//       required this.onTabChange});

//   bool isExpanded = false;

//   List<Widget> panels;
//   List<Map<String, IconData>> tabs;
//   Function onTabChange;

//   final _key = GlobalKey<ScaffoldState>();

//   openDrawer() {
//     _key.currentState?.openDrawer();
//   }

//   @override
//   State<PANEL> createState() => _PANELState();
// }

// class _PANELState extends State<PANEL> {
//   final SidebarXController _controller = SidebarXController(selectedIndex: 0);

//   late List<Widget> panels;
//   List<SidebarXItem> tabs = [];
//   int selectedIndex = 0;

//   go(int i) {
//     setState(() => selectedIndex = i);
//     widget.onTabChange(i);
//   }

//   @override
//   Widget build(BuildContext context) {
//     setState(() {
//       panels = widget.panels;
//       tabs = [];
//       for (var i = 0; i < widget.tabs.length; i++) {
//         widget.tabs[i].forEach((k, v) {
//           tabs.add(SidebarXItem(
//             icon: v,
//             label: k.toString(),
//             onTap: () {
//               go(i);
//             },
//           ));
//         });
//       }
//     });
//     _controller.selectIndex(selectedIndex);
//     return Scaffold(
//       key: widget._key,
//       drawerScrimColor: Colors.black54,
//       drawer: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           SidebarX(
//               headerBuilder: (context, extended) {
//                 return Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(children: [
//                       Image.asset("assets/logo/logowhite.png",
//                           width: 30, height: 30),
//                       if (extended) const SizedBox(width: 10),
//                       if (extended)
//                         LABEL(
//                             text: 'Amoi Groupe', size: 15, isBold: true, color: Colors.white)
//                     ]),
//                   ),
//                 );
//               },
//               headerDivider: Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//                 child: Container(
//                     color: Colors.white30, width: double.maxFinite, height: 1),
//               ),
//               controller: _controller,
//               theme: SidebarXTheme(
//                   margin: const EdgeInsets.fromLTRB(10, 25, 0, 25),
//                   decoration: BoxDecoration(
//                       color: Colors.black,
//                       borderRadius: BorderRadius.circular(10)),
//                   hoverColor: Colors.black,
//                   textStyle: const TextStyle(color: Colors.white70),
//                   selectedTextStyle: const TextStyle(color: Colors.white),
//                   itemTextPadding: const EdgeInsets.only(left: 10),
//                   selectedItemTextPadding: const EdgeInsets.only(left: 10),
//                   selectedItemDecoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       gradient: const LinearGradient(
//                           colors: [Colors.blue, Colors.blueAccent])),
//                   iconTheme:
//                       const IconThemeData(color: Colors.white70, size: 20),
//                   selectedIconTheme:
//                       const IconThemeData(color: Colors.white, size: 20),
//                   padding: const EdgeInsets.all(10),
//                   selectedItemPadding: const EdgeInsets.all(10),
//                   itemPadding: const EdgeInsets.all(10)),
//               extendedTheme: const SidebarXTheme(
//                   width: 200, decoration: BoxDecoration(color: Colors.black)),
//               items: tabs),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(0, 0, 25, 25),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 LABEL(
//                     text: 'AMOI APP v$version',
//                     color: Colors.white,
//                     size: 11,
//                     isBold: true),
//                 LABEL(text: 'by : BO STUDIO mg', color: Colors.white, size: 10),
//               ],
//             ),
//           )
//         ],
//       ),
//       body: panels.elementAt(selectedIndex),
//     );
//   }
// }