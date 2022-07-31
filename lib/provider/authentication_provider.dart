import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_plus/util/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_plus/util/shared_pref.dart';

class AuthenticationProvider extends ChangeNotifier with Helper {
  bool _isLoading = false;
  bool get loading => _isLoading;
  var firestore = FirebaseFirestore.instance.collection('grocery').doc('users');
  var firebaseAuthInstance = FirebaseAuth.instance;
  UserCredential? userCredential; 


  Future<void> userAuthenticate(bool isLogin,BuildContext _context,String name, String email, String password) async {
    if (await validation(context: _context,isLogin: isLogin,name: name,email: email,password: password)) {
      _isLoading = true;
      notifyListeners();
      try {
        isLogin
        ? userCredential = await firebaseAuthInstance.signInWithEmailAndPassword(email: email, password: password)
        : userCredential = await firebaseAuthInstance.createUserWithEmailAndPassword(email: email, password: password);
        SharedPref.setUserEmail(email);
        SharedPref.setLogin(true);
        SharedPref.setUserId(userCredential!.user!.uid);
        if(!isLogin) {
          var collection = firestore.collection(userCredential!.user!.uid);
          var batch = FirebaseFirestore.instance.batch();
          batch.set(collection.doc('details'), {'name':name,'email': email});
          batch.set(collection.doc('cart'), {'enable': true});
          batch.commit();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showSnackbar(_context,'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          showSnackbar(_context,'The account already exists for that email.');
        } else if (e.code == 'user-not-found') {
          showSnackbar(_context,'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          showSnackbar(_context,'Wrong password provided for that user.');
        }
      } catch (e) {
        showSnackbar(_context, e.toString());
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  // void fillEmailPassword(String name,String email,String password){
  //   if(_isLogin){
  //     if(email.isNotEmpty && password.isNotEmpty){
  //       _emailPaswordAvail = true;
  //     }else{
  //       _emailPaswordAvail = false;
  //     } 
  //   }else{
  //     if(email.isNotEmpty && password.isNotEmpty && name.isNotEmpty){
  //       _emailPaswordAvail = true;
  //     }else{
  //       _emailPaswordAvail = false;
  //     }
  //   }
  //   notifyListeners();
  // }

  // void passwordVisibility(){
  //   _showPassword = _showPassword ? false : true;
  //   notifyListeners();
  // }



  Future<bool> validation({required BuildContext context,required bool isLogin,required String name, required String email, required String password}) async{
    if(!isLogin && name.isEmpty){
      showSnackbar(context, 'Please provider name');
      return false;
    }
    if (email.isEmpty) {
      showSnackbar(context, 'Please provide email');
      return false;
    } else if(!validateEmail(email)){
      showSnackbar(context, 'Invalid Email');
      return false;
    } else if (password.isEmpty) {
      showSnackbar(context, 'Please provide password');
      return false;
    }else if(password.length < 6){
      showSnackbar(context, 'Weak Password!!! Length of Password Should be atleast 6');
      return false;
    }else if(!await checkInternetConnection()){
      showSnackbar(context, 'No Internet Connection');
      return false;
    }
    return true;
  }

}
