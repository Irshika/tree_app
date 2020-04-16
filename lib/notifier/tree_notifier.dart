import 'dart:collection';

import 'package:tree_app/model/Tree.dart';
import 'package:flutter/cupertino.dart';

class TreeNotifier with ChangeNotifier {
  List<Tree> _treeList = [];
  Tree _currentTree;

  UnmodifiableListView<Tree> get treeList => UnmodifiableListView(_treeList);

  Tree get currentTree => _currentTree;

  set treeList(List<Tree> treeList) {
    _treeList = treeList;
    notifyListeners();
  }

  set currentTree(Tree tree) {
    _currentTree = tree;
    notifyListeners();
  }

  addTree(Tree tree) {
    _treeList.insert(0, tree);
    notifyListeners();
  }

  deleteTree(Tree tree) {
    _treeList.removeWhere((_tree) => _tree.id == tree.id);
    notifyListeners();
  }
}
