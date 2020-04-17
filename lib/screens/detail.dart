import 'package:tree_app/api/tree_api.dart';
import 'package:tree_app/model/Tree.dart';
import 'package:tree_app/notifier/tree_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tree_form.dart';

class TreeDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TreeNotifier treeNotifier = Provider.of<TreeNotifier>(context, listen: false);

    _onTreeDeleted(Tree tree) {
      Navigator.pop(context);
      treeNotifier.deleteTree(tree);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(treeNotifier.currentTree.name),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Image.network(
                  treeNotifier.currentTree.image != null
                      ? treeNotifier.currentTree.image
                      : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: 24),
                Text(
                  treeNotifier.currentTree.name,
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                Text(
                  //'Category: ${treeNotifier.currentTree.description}',
                  treeNotifier.currentTree.description,
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 20),
                Text(
                  "Ingredients",
                  style: TextStyle(fontSize: 18, decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'button1',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return TreeForm(
                    isUpdating: true,
                  );
                }),
              );
            },
            child: Icon(Icons.edit),
            foregroundColor: Colors.white,
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            heroTag: 'button2',
            onPressed: () => deleteTree(treeNotifier.currentTree, _onTreeDeleted),
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
