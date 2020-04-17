import 'dart:io';

import 'package:tree_app/api/tree_api.dart';
import 'package:tree_app/model/Tree.dart';
import 'package:tree_app/notifier/tree_notifier.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class TreeForm extends StatefulWidget {
  final bool isUpdating;

  TreeForm({@required this.isUpdating});

  @override
  _TreeFormState createState() => _TreeFormState();
}

class _TreeFormState extends State<TreeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //List _subingredients = [];
  Tree _currentTree;
  String _imageUrl;
  File _imageFile;
  //TextEditingController subingredientController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    TreeNotifier treeNotifier = Provider.of<TreeNotifier>(context, listen: false);

    if (treeNotifier.currentTree != null) {
      _currentTree = treeNotifier.currentTree;
    } else {
      _currentTree = Tree();
    }

    //_imageUrl = _currentTree.image;
    _imageUrl = treeNotifier.currentTree.image;
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Text("image placeholder");
    } else if (_imageFile != null) {
      print('showing image from local file');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    } else if (_imageUrl != null) {
      print('showing image from url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }
  }

  _getLocalImage() async {
    File imageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      initialValue: _currentTree.name,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Name must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentTree.name = value;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Description'),
      initialValue: _currentTree.description,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Description is required';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Description must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentTree.description = value;
      },
    );
  }

  _onTreeUploaded(Tree tree) {
    TreeNotifier treeNotifier = Provider.of<TreeNotifier>(context, listen: false);
    treeNotifier.addTree(tree);
    Navigator.pop(context);
  }

  _saveTree() {
    print('saveTree Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');

    uploadTreeAndImage(_currentTree, widget.isUpdating, _imageFile, _onTreeUploaded);

    print("name: ${_currentTree.name}");
    print("category: ${_currentTree.description}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Tree Form')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(children: <Widget>[
            _showImage(),
            SizedBox(height: 16),
            Text(
              widget.isUpdating ? "Edit Tree" : "Create Tree",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 16),
            _imageFile == null && _imageUrl == null
                ? ButtonTheme(
                    child: RaisedButton(
                      onPressed: () => _getLocalImage(),
                      child: Text(
                        'Add Image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : SizedBox(height: 0),
            _buildNameField(),
            _buildDescriptionField(),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveTree();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }


}
