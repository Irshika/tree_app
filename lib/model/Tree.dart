
import 'package:cloud_firestore/cloud_firestore.dart';

class Tree {
  String id;
  String name;
  String description;
  //String category;
  String image;
  //List subIngredients = [];
  Timestamp createdAt;
  Timestamp updatedAt;

  Tree();

  Tree.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    description = data['description'];
    //category = data['category'];
    image = data['image'];
    //subIngredients = data['subIngredients'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}