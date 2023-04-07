// ignore_for_file: camel_case_types

import 'package:amoi/component/button.dart';
import 'package:amoi/component/input.dart';
import 'package:amoi/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SCREEN_TODO extends StatefulWidget {
  const SCREEN_TODO({super.key});

  @override
  State<SCREEN_TODO> createState() => _SCREEN_TODOState();
}

class _SCREEN_TODOState extends State<SCREEN_TODO> {
  List<Map<String, dynamic>> todoList = [];
  INPUT title = INPUT(label: 'Titre');
  INPUT subTitle = INPUT(label: 'Description');
  bool isConstruct = true;

  @override
  Widget build(BuildContext context) {
    setStatutBarTheme();
    toast.init(context);
    if (isConstruct) {
      _getTODO();
      setState(() => isConstruct = false);
    }
    return Scaffold(
        appBar: AppBar(
            title: const Text('TODO'),
            surfaceTintColor: Colors.white),
        body: ListView(children: _getItems()),
        floatingActionButton: FloatingActionButton(
            onPressed: () => _displayDialog(context),
            tooltip: 'Ajouter',
            child: const Icon(Icons.add)));
  }

  // ========================================================
  // Generate a single item widget
  _getTODO() {
    loading.show("Chargement de la liste ...");
    base.selectListTODO('dateAjout', (list) {
      setState(() => todoList = []);
      for (Map<String, dynamic> m in list) {
        setState(() => todoList.add(m));
      }
      loading.hide();
    });
  }

  // Generate a single item widget
  _addTODO(Map<String, dynamic> todo) async {
    await base.newTODO(todo['dateAjout'].toString(), todo);
    _getTODO();
  }

  // Generate a single item widget
  _removeTODO(Map<String, dynamic> todo) async {
    await base.deleteTODO(todo['dateAjout'].toString());
    _getTODO();
  }

  // Generate a single item widget
  _updateTODO(Map<String, dynamic> todo) async {
    await base.updateChecTODO(todo['dateAjout'].toString(), todo['traiter']);
    _getTODO();
  }

  // ========================================================
  // Generate a single item widget
  void _addTodoItem() {
    setState(() {
      Map<String, dynamic> m = {
        'titre': title.getValue(),
        'description': subTitle.getValue(),
        'dateAjout': Timestamp.now(),
        'traiter': false,
        'dateTraiter': Timestamp.now(),
      };
      todoList.add(m);
      title.setText('');
      subTitle.setText('');
      _addTODO(m);
    });
  }

  // Generate list of item widgets
  Widget _buildTodoItem(Map<String, dynamic> todo) {
    return ListTile(
        title: Text(todo['titre']),
        leading: BUTTON(
            text: '',
            action: () {
              for (var i = 0; i < todoList.length; i++) {
                if (todoList[i]['dateAjout'] == todo['dateAjout']) {
                  setState(() {
                    todoList[i]['traiter'] = !todoList[i]['traiter'];
                    todoList[i]['dateTraiter'] = Timestamp.now();
                  });
                  _updateTODO(todoList[i]);
                }
              }
            },
            type: 'ICON')
          ..icon = todo['traiter']
              ? Icons.check_box_rounded
              : Icons.check_box_outline_blank,
        subtitle: Text(todo['description']),
        trailing: BUTTON(
            text: '',
            action: () async {
              for (var i = 0; i < todoList.length; i++) {
                if (todoList[i]['dateAjout'] == todo['dateAjout']) {
                  await _removeTODO(todoList[i]);
                  setState(() {
                    todoList.remove(todoList[i]);
                  });
                }
              }
            },
            type: 'ICON')
          ..icon = Icons.delete);
  }

  // Generate a single item widget
  Future<Future> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              scrollable: true,
              title: const Text('Ajouter nouveau'),
              content: Column(
                  children: [title, const SizedBox(height: 10), subTitle]),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Ajouter'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _addTodoItem();
                  },
                ),
                ElevatedButton(
                    child: const Text('Annuler'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  List<Widget> _getItems() {
    final List<Widget> _todoWidgets = <Widget>[];
    for (Map<String, dynamic> todo in todoList) {
      _todoWidgets.add(_buildTodoItem(todo));
    }
    return _todoWidgets;
  }
}
