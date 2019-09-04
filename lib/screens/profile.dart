import 'package:flutter/material.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget{

  final AuthService auth = AuthService();

@override
  Widget build(BuildContext context) {
    
    var user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(user.email)
      ),
      body: Center(
        child: FlatButton(
          child: Text('logout'),
          color: Colors.red,
          onPressed: () async {
            Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (route) => false);
          },
        ),
      ),
    );


  }

}