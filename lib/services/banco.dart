import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:listadecoisa/classes/coisas.dart';
import 'package:listadecoisa/classes/user.dart';
import 'package:listadecoisa/services/global.dart';
import 'package:translator/translator.dart';

class BancoFire {
  final translator = GoogleTranslator();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserP usuario;
  BancoFire();

  criaAlteraCoisas({Coisas coisas, UserP user}) {
    if (coisas.idFire == null) {
      coisas.idFire =
          db.collection('user').doc(user.id).collection('coisas').doc().id;
    }
    db
        .collection('user')
        .doc(user.id)
        .collection('coisas')
        .doc(coisas.idFire)
        .set(coisas.toJson());
  }

  getCoisas({UserP user}) async {
    try {
      var result =
          await db.collection('user').doc(user.id).collection('coisas').get();
      return result.docs;
    } catch (e) {
      var auxi = await translator.translate(e.message, from: 'en', to: 'pt');
      Fluttertoast.showToast(
          msg: auxi.text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0);
      return null;
    }
  }

  removeCoisas({Coisas cat, UserP user}) async {
    db
        .collection('user')
        .doc(user.id)
        .collection('coisas')
        .doc(cat.idFire)
        .delete();
  }

  getMoviment({UserP user}) async {
    var result =
        await db.collection('user').doc(user.id).collection('moviment').get();

    return result.docs;
  }

  Future<String> criaUser(UserP user) async {
    try {
      var userFire = await _firebaseAuth.createUserWithEmailAndPassword(
          email: user.login, password: user.senha);

      user.id = userFire.user.uid;
      db.collection('user').doc(userFire.user.uid).set(user.toJson());
      return userFire.user.uid;
    } catch (erro) {
      var auxi = await translator.translate(erro.message, from: 'en', to: 'pt');
      Fluttertoast.showToast(
          msg: auxi.text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0);
      return '';
    }
  }

  Future<UserP> login({String email, String password}) async {
    try {
      var _value = await _firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(), password: password);

      DocumentSnapshot result =
          await db.collection('user').doc(_value.user.uid).get();

      UserP auxi = new UserP(
        login: result.data()['login'],
        id: result.data()['id'],
        nome: result.data()['nome'],
        //senha: result.data()['senha'],
      );

      return auxi;
    } catch (e) {
      var auxi = await translator.translate(e.message, from: 'en', to: 'pt');
      Fluttertoast.showToast(
          msg: auxi.text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0);
      return null;
    }
  }

  Future<UserP> criaUserAnonimo() async {
    try {
      UserP user = new UserP();
      var axui = prefs.getString('userAnonimo') ?? '';
      if (axui.isNotEmpty) {
        DocumentSnapshot result = await db
            .collection('user')
            .doc(prefs.getString('userAnonimo'))
            .get();

        user.id = result.data()['id'];
      } else {
        var _value = await _firebaseAuth.signInAnonymously();
        user.id = _value.user.uid;
        db.collection('user').doc(user.id).set(user.toJson());
        prefs.setString('userAnonimo', user.id);
      }

      return user;
    } catch (e) {
      var auxi = await translator.translate(e.message, from: 'en', to: 'pt');
      Fluttertoast.showToast(
          msg: auxi.text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0);
      return null;
    }
  }

  Future<void> resetarSenha({UserP user}) {
    _firebaseAuth.sendPasswordResetEmail(email: user.login);
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
