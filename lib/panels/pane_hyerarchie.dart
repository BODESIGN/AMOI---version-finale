import 'package:amoi/component/label.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

class MYHYERARCHY extends StatefulWidget {
  const MYHYERARCHY({Key? key}) : super(key: key);

  reloadListe() {}

  @override
  State<MYHYERARCHY> createState() => _MYHYERARCHYState();
}

class _MYHYERARCHYState extends State<MYHYERARCHY> {
  bool isConstruct = true;
  List<Map> listUsers = [];
  List<TreeNode> vuTree = [];

  getChildren(String parent, BuildContext context) {
    List<TreeNode> childrenTree = [];
    for (var user in listUsers) {
      if (user['parent'].toString() == parent) {
        late TreeNode childTree;
        if (user['childs-direct'].length > 0) {
          childTree = TreeNode(
              content: Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: pdp(user['urlPdp'].toString(), () {
                      showProfile(context, user as Map<String, dynamic>);
                    }),
                  ),
                  const SizedBox(width: 5),
                  LABEL(text: user['fullname'].toString(), isBold: true),
                ],
              ),
              children: getChildren(user['login'], context));
        } else {
          childTree = TreeNode(
              content: Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: pdp(user['urlPdp'].toString(), () {
                      showProfile(context, user as Map<String, dynamic>);
                    }),
                  ),
                  const SizedBox(width: 5),
                  LABEL(text: user['fullname'].toString()),
                ],
              ),
              children: []);
        }
        childrenTree.add(childTree);
      }
    }
    return childrenTree;
  }

  getList(BuildContext context) {
    loading.show("Chargement de fiche ...");
    base.selectListUsers((list) {
      setState(() {
        listUsers = [];
        for (var u in list) {
          listUsers.add(u as Map);
        }

        vuTree = [
          TreeNode(
              content: Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: pdp(userActif['urlPdp'].toString(), () {
                      showProfile(context, userActif);
                    }),
                  ),
                  const SizedBox(width: 5),
                  LABEL(text: userActif['fullname'], isBold: true),
                ],
              ),
              children: getChildren(userActif['login'], context))
        ];
      });
      loading.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    setStatutBarTheme();
    if (isConstruct) {
      getList(context);
      setState(() {
        isConstruct = false;
      });
    }

    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, child: TreeView(nodes: vuTree)),
      ),
    );
  }
}
