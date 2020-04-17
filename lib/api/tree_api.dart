

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tree_app/model/Tree.dart';
import 'package:tree_app/notifier/auth_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tree_app/model/user.dart';
import 'package:tree_app/notifier/tree_notifier.dart';
import 'package:path/path.dart' as path;
//import 'package:uuid/uuid.dart';

login(User user, AuthNotifier authNotifier) async{
  
AuthResult authResult =  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

    if(authResult != null){
      FirebaseUser firebaseUser = authResult.user;

      if(firebaseUser != null){
        print("Log In: $firebaseUser");
        authNotifier.setUser(firebaseUser);
      }
    }
}

signup(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
      email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = user.displayName;

    FirebaseUser firebaseUser = authResult.user;


    if (firebaseUser != null) {
      await firebaseUser.updateProfile(updateInfo);

      await firebaseUser.reload();

      print("Sign Up: $firebaseUser");

      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      authNotifier.setUser(currentUser);
    }
  }
}

signout(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance.signOut().catchError((error) => print(error.code));

  authNotifier.setUser(null);
}

initializeCurrentUser(AuthNotifier authNotifier) async{
  FirebaseUser firebaseUser  = await FirebaseAuth.instance.currentUser();

  if(firebaseUser != null){
    authNotifier.setUser(firebaseUser);
  }
}


getTrees(TreeNotifier treeNotifier) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('Trees')
      .orderBy("createdAt", descending: true)
      .getDocuments();

  List<Tree> _treeList = [];

  snapshot.documents.forEach((document) {
    Tree tree = Tree.fromMap(document.data);
    _treeList.add(tree);
  });

  treeNotifier.treeList = _treeList;
}

uploadTreeAndImage(Tree tree, bool isUpdating, File localFile, Function treeUploaded) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('trees/images/$uuid$fileExtension');

    await firebaseStorageRef.putFile(localFile).onComplete.catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    _uploadTree(tree, isUpdating, treeUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _uploadTree(tree, isUpdating, treeUploaded);
  }
}

_uploadTree(Tree tree, bool isUpdating, Function treeUploaded, {String imageUrl}) async {
  CollectionReference treeRef = Firestore.instance.collection('Trees');

  if (imageUrl != null) {
    tree.image = imageUrl;
  }

  if (isUpdating) {
    tree.updatedAt = Timestamp.now();

    await treeRef.document(tree.id).updateData(tree.toMap());

    treeUploaded(tree);
    print('updated tree with id: ${tree.id}');
  } else {
    tree.createdAt = Timestamp.now();

    DocumentReference documentRef = await treeRef.add(tree.toMap());

    tree.id = documentRef.documentID;

    print('uploaded tree successfully: ${tree.toString()}');

    await documentRef.setData(tree.toMap(), merge: true);

    treeUploaded(tree);
  }
}

deleteTree(Tree tree, Function treeDeleted) async {
  if (tree.image != null) {
    StorageReference storageReference =
    await FirebaseStorage.instance.getReferenceFromUrl(tree.image);

    print(storageReference.path);

    await storageReference.delete();

    print('image deleted');
  }

  await Firestore.instance.collection('Trees').document(tree.id).delete();
  treeDeleted(tree);
}