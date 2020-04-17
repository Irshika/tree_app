//import 'dart:collection';
//
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:tree_app/model/tree.dart';
//
//class TreeNotifier with ChangeNotifier{
//  List<Tree> _treeList = [];
//  Tree _currentTree;
//
//  UnmodifiableListView<Tree> get treeList => UnmodifiableListView(_treeList);
//
//  Tree get currentTree => _currentTree;
//
//  set treeList(List<Tree> treeList){
//    _treeList = treeList;
//    notifyListeners();
//  }
//
//  set currentTree(Tree tree){
//    _currentTree = tree;
//    notifyListeners();
//  }
//}

import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:tree_app/model/Tree.dart';

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