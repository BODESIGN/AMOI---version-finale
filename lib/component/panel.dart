import 'package:amoi/component/appbar.dart';
import 'package:amoi/component/label.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';

// // ignore: must_be_immutable
// class PANELSAVE extends StatefulWidget {
//   PANELSAVE(
//       {super.key,
//       required this.tabs,
//       required this.panels,
//       required this.onTabChange});

//   bool isExpanded = false;

//   List<Widget> panels;
//   List<Map<String, IconData>> tabs;
//   Function onTabChange;

//   @override
//   State<PANELSAVE> createState() => _PANELSAVEState();
// }

// class _PANELSAVEState extends State<PANELSAVE> {
//   late List<Widget> panels;
//   List<SideNavigationBarItem> tabs = [];
//   int selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     setState(() {
//       panels = widget.panels;
//       tabs = [];
//       for (var element in widget.tabs) {
//         element.forEach((k, v) {
//           tabs.add(SideNavigationBarItem(icon: v, label: k.toString()));
//         });
//       }
//     });
//     return Row(children: [
//       SideNavigationBar(
//           selectedIndex: selectedIndex,
//           initiallyExpanded: false,
//           items: tabs,
//           onTap: (index) {
//             setState(() => selectedIndex = index);
//             widget.onTabChange(index);
//           },
//           toggler: SideBarToggler(
//             expandIcon: Icons.menu,
//             shrinkIcon: Icons.keyboard_arrow_left_sharp,
//             onToggle: () =>
//                 setState(() => widget.isExpanded = !widget.isExpanded),
//           ),
//           theme: SideNavigationBarTheme(
//             backgroundColor: Colors.black,
//             itemTheme: SideNavigationBarItemTheme(
//                 unselectedItemColor: Colors.white38,
//                 selectedItemColor: Colors.blue,
//                 iconSize: 20,
//                 labelTextStyle:
//                     const TextStyle(fontSize: 12, color: Colors.blue)),
//             togglerTheme: const SideNavigationBarTogglerTheme(
//                 expandIconColor: Colors.blue, shrinkIconColor: Colors.white),
//             dividerTheme: SideNavigationBarDividerTheme.standard(),
//           )),
//       Expanded(child: panels.elementAt(selectedIndex))
//     ]);
//   }
// }

// ==================================================
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
  List<Widget> tabs = [];
  int selectedIndex = 0;

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    setState(() {
      panels = widget.panels;
      tabs = [];
      for (var i = 0; i < widget.tabs.length; i++) {
        widget.tabs[i].forEach((k, v) {
          tabs.add(Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                  padding: isExpanded
                      ? const EdgeInsets.fromLTRB(15, 10, 15, 10)
                      : const EdgeInsets.all(10),
                  child: InkWell(
                      onTap: (() {
                        setState(() => selectedIndex = i);
                        widget.onTabChange(i);
                      }),
                      child: Row(children: [
                        Container(
                          decoration: BoxDecoration(
                            color: i == selectedIndex
                                ? Colors.amber
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Icon(v,
                                color: i == selectedIndex
                                    ? Colors.black
                                    : Colors.white54),
                          ),
                        ),
                        if (isExpanded) const SizedBox(width: 5),
                        if (isExpanded)
                          LABEL(
                              text: k.toString(),
                              isBold: i == selectedIndex,
                              color: i == selectedIndex
                                  ? Colors.white
                                  : Colors.white54)
                      ])))));
        });
      }
    });

    return Container(
        color: Colors.black,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          APPBAR(user: userActif),
          Expanded(
              child: Row(children: [
            Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                // decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // header
                      Expanded(
                          child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: tabs),
                      )),

                      // footer
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                              padding: isExpanded
                                  ? const EdgeInsets.fromLTRB(15, 10, 15, 10)
                                  : const EdgeInsets.all(10),
                              child: InkWell(
                                  onTap: () =>
                                      setState(() => isExpanded = !isExpanded),
                                  child: Icon(
                                      isExpanded
                                          ? Icons.arrow_left_outlined
                                          : Icons.arrow_right_outlined,
                                      color: Colors.white))))
                    ])),
            Expanded(
                child: Card(
                    elevation: 10,
                    margin: const EdgeInsets.all(10),
                    surfaceTintColor: Colors.white,
                    child: Container(
                        // decoration: const BoxDecoration(
                        //     border: Border(
                        //         left: BorderSide(
                        //             width: 2, color: Colors.white))),
                        child: panels.elementAt(selectedIndex))))
          ]))
        ]));
  }
}
