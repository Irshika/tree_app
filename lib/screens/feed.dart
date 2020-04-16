import 'package:tree_app/api/tree_api.dart';
import 'package:tree_app/notifier/auth_notifier.dart';
import 'package:tree_app/notifier/tree_notifier.dart';
import 'package:tree_app/screens/detail.dart';
import 'package:tree_app/screens/tree_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  void initState() {
    TreeNotifier treeNotifier = Provider.of<TreeNotifier>(context, listen: false);
    getTrees(treeNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    TreeNotifier treeNotifier = Provider.of<TreeNotifier>(context);

    Future<void> _refreshList() async {
      getTrees(treeNotifier);
    }

    print("building Feed");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          authNotifier.user != null ? authNotifier.user.displayName : "Feed",
        ),
        actions: <Widget>[
          // action button
          FlatButton(
            onPressed: () => signout(authNotifier),
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
      body: new RefreshIndicator(
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Image.network(
                treeNotifier.treeList[index].image != null
                    ? treeNotifier.treeList[index].image
                    : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                width: 120,
                fit: BoxFit.fitWidth,
              ),
              title: Text(treeNotifier.treeList[index].name),
              subtitle: Text(treeNotifier.treeList[index].category),
              onTap: () {
                treeNotifier.currentTree = treeNotifier.treeList[index];
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return TreeDetail();
                }));
              },
            );
          },
          itemCount: treeNotifier.treeList.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.black,
            );
          },
        ),
        onRefresh: _refreshList,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          treeNotifier.currentTree = null;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return TreeForm(
                isUpdating: false,
              );
            }),
          );
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
      ),
    );
  }
}
