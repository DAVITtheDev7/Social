import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social/model/post_model.dart';
import 'package:social/auth/sign_in.dart';
import 'package:intl/intl.dart';
import '../widgets/upload_post_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;
  String? username;
  Map<String, String> userNames = {};

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _fetchUsername();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      });
    }

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  Future<void> _fetchUsername() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            username = userDoc.get('username');
          });
        } else {
          print('User document does not exist.');
        }
      } catch (e) {
        print('Error fetching username: $e');
      }
    }
  }

  Future<Map<String, String>> _fetchUsernames(List<String> userIds) async {
    final Map<String, String> usernames = {};

    if (userIds.isEmpty) return usernames;

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: userIds)
          .get();

      for (var doc in snapshot.docs) {
        usernames[doc.id] = doc.get('username') ?? 'Unknown User';
      }

      for (var id in userIds) {
        if (!usernames.containsKey(id)) {
          usernames[id] = 'Unknown User';
        }
      }
    } catch (e) {
      print('Error fetching usernames: $e');
      for (var id in userIds) {
        usernames[id] = 'Unknown User';
      }
    }

    return usernames;
  }

  void _getBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    _getBack();
  }

  void _uploadPost() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UploadPostDialog(
          onPostAdded: () {
            setState(() {});
          },
        );
      },
    );
  }

  Future<void> deleteTask(String postId) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
      // print('Post deleted successfully');
    } catch (e) {
      print('Error deleting post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome, ${username ?? 'Loading...'}',
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var posts = snapshot.data!.docs;

          List<String> userIds =
              posts.map((post) => post['userId'] as String).toList();
          if (userIds.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }

          return FutureBuilder<Map<String, String>>(
            future: _fetchUsernames(userIds),
            builder: (context, usernameSnapshot) {
              if (usernameSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (usernameSnapshot.hasError) {
                return Center(child: Text('Error: ${usernameSnapshot.error}'));
              }

              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  var post = posts[index];
                  String authorUsername =
                      usernameSnapshot.data?[post['userId'] as String] ??
                          'Unknown';
                  String postDate = DateFormat('yyyy/MM/dd HH:mm').format(
                      (post['timestamp'] as Timestamp).toDate().toLocal());
                  return Dismissible(
                    key: Key(post.id),
                    onDismissed: (direction) {
                      deleteTask(post.id);
                      setState(() {});
                    },
                    background: Container(color: Colors.red),
                    child: UserPost(
                      username: authorUsername,
                      title: post['title'],
                      content: post['content'],
                      date: postDate,
                      deleteFunction: (context) => deleteTask(post.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        onPressed: _uploadPost,
        tooltip: 'Upload Post',
        child: const Icon(Icons.add),
      ),
    );
  }
}
