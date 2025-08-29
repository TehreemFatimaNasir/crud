import 'dart:async';
import 'package:crud/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Splashscreen(),
    );
  }
}

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    final user = auth.currentUser;
    super.initState();

    Timer(Duration(seconds: 4), () {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeSCR()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Loginscreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Registration System", style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF556B2F),
          ),)));
  }
}

class SignUpscreen extends StatefulWidget {
  const SignUpscreen({super.key});

  @override
  State<SignUpscreen> createState() => _SignUpscreenState();
}

class _SignUpSCRState extends State<SignUpscreen> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
          color: const Color(0xFF556B2F),

            height: 150,
            width: double.infinity,
            child: Center(
              child: Text(
                "Signup Page",
                style: TextStyle(fontSize: 28, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: name,
              decoration: InputDecoration(
                prefix: Icon(Icons.person),
                
                label: Text("Enter Your Name"),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefix: Icon(Icons.email),
                hintText: "someone@abc.com",
                label: Text("Enter Your Email"),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: pass,
              obscureText: true,
           
              decoration: InputDecoration(
                prefix: Icon(Icons.password),
                hintText: "alphaNumeric",
                label: Text("Enter Your Password"),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              try {
                final credential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                  email: email.text.toString(),
                  password: pass.text.toString(),
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Homescreen()),
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print('The password provided is too weak.');
                } else if (e.code == 'email-already-in-use') {
                  print('The account already exists for that email.');
                }
              } catch (e) {
                print(e);
              }
            },
            child: Text("Signup"),
          ),
        ],
      ),
    );
  }
}

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
           color: const Color(0xFF556B2F),

            height: 150,
            width: double.infinity,
            child: Center(
              child: Text(
                "Login Page",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: email,
              decoration: InputDecoration(
                prefix: Icon(Icons.email),
                hintText: "someone@abc.com",
                label: Text("Enter Your Email"),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: pass,
              obscureText: true,
              decoration: InputDecoration(
                prefix: Icon(Icons.password),
                hintText: "alphaNumeric",
                label: Text("Enter Your Password"),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                  email: email.text.toString(),
                  password: pass.text.toString(),
                )
                    .then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>  Homescreen()),
                  );
                });
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print('No user found for that email.');
                } else if (e.code == 'wrong-password') {
                  print('Wrong password provided for that user.');
                }
              }
            },
            child: Text("Login"), 
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpscreen()),
              );
            },
            child: Text("Don’t have an account? Signup", style: TextStyle(color: Color(0xFF556B2F))),
          ),
        ],
      ),
    );
  }
}

class  Homescreen extends StatefulWidget {
  const  Homescreen({super.key});

  @override
  State< Homescreen> createState() => _ HomescreenState();
}

class _ HomescreenState extends State<Homescreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref("learner");
  final key = FirebaseAuth.instance.currentUser!.uid;

  int id = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Loginscreen()),
              );
            },
            icon: Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                label: Text("Search BY Title"),
                hintText: "Search Here",
              ),
              onChanged: (String value) {
                setState(() {}); 
              },
            ),
          ),

   Expanded(
  child: StreamBuilder(
    stream: databaseReference.child(key).onValue,
    builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }
      final items = snapshot.data!.snapshot.children.toList();

      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final data = items[index].value as Map;
          String title = data["Title"].toString();

          if (title.contains(searchController.text)) {
            return ListTile(
              title: Text(data["Title"].toString()),
              subtitle: Text(data["Description"].toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      final id = data["ID"].toString();
                      databaseReference.child(key).child(id).remove();
                    },
                    icon: Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {
                      final id = data["ID"];
                      mymodelfunction(id);
                    },
                    icon: Icon(Icons.edit),
                  ),
                ],
              ),
            );
          } else {
            return Container(); 
          }
        },
      );
    },
  ),
),

           ]),   floatingActionButton: FloatingActionButton(
        onPressed: () {
          mymodelfunction(null);
        },
        child: Icon(Icons.add),
      ),
    );
  }

 void mymodelfunction(var postID) {
    titleController.clear();
    descController.clear();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            32,
            32,
            32,
            MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: "Enter Your Title"),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(hintText: "Enter Your description"),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  String title = titleController.text.toString();
                  String desc = descController.text.toString();

                  if (postID == null) {

                    id++;

                    await databaseReference
                        .child(key)
                        .child("$id")
                        .set({
                          "ID": id,
                          "Title": title,
                          "Description": desc,
                          "DateOfPost": DateTime.now().toString(),
                        })
                        .then((value) {
                          print("Successfully created ");
                        })
                        .onError((error, stackTrace) {
                          print("failed task ");
                        });
                  }else{
                      await databaseReference
                        .child(key)
                        .child("$postID")
                        .update({
                          "ID": postID,
                          "Title": titleController.text,
                          "Description": descController.text,
                          "DateOfPost": DateTime.now().toString(),
                        })
                        .then((value) {
                          print("Successfully updated");
                        })
                        .onError((error, stackTrace) {
                          print("failed task ");
                        });
                  }
                },
                child: postID==null? Text("ADD"):Text("Update"),
              ),
            ],
          ),
        );
      },
    );
  }
}
