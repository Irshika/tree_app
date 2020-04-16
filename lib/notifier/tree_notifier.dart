import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tree_app/model/tree.dart';

class TreeNotifier with ChangeNotifier{
  List<Tree> _treeList = [];
  Tree _currentTree;

  UnmodifiableListView<Tree> get treeList => UnmodifiableListView(_treeList);

  Tree get cureentTree => _currentTree;

  set treeList(List<Tree> treeList){
    _treeList = treeList;
    notifyListeners();
  }

  set currentTree(Tree tree){
    _currentTree = tree;
    notifyListeners();
  }
}